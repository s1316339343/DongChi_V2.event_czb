/**
 * DietDashboard - 饮食统计仪表盘
 *
 * 对本地决策记录做可视化统计分析：
 * - 各口味占比（饼图）
 * - 平均花费趋势（折线图）
 * - 最常选的菜 Top 10（横向柱状图）
 * - 时间偏好分布（饼图）
 * - 预算偏好分布（柱状图）
 * - 饮食限制统计
 * - 概览数据卡片
 */
import { promptAction } from '@kit.ArkUI';
import router from '@ohos.router';
import { common } from '@kit.AbilityKit';
import { DecisionRecord, DbService } from '../service/DbService';

/** 从 results JSON 解析出的菜品简要数据 */
interface ParsedDish {
  name: string;
  icon: string;
  cost: string;
  cookCost: number;
  difficulty: string;
  category: number;
  categoryName: string;
}

/** 口味统计数据 */
interface CategoryStat {
  name: string;
  count: number;
  color: string;
}

/** Top 菜品统计 */
interface DishCount {
  name: string;
  icon: string;
  count: number;
}

/** 预算偏好统计 */
interface BudgetStat {
  label: string;
  count: number;
}

/** 时间偏好统计 */
interface TimeStat {
  label: string;
  count: number;
}

/** 花费趋势数据点 */
interface CostTrendPoint {
  label: string;   // 月份: "1月"
  avgCost: number; // 平均花费
}

/** 饮食限制统计 */
interface DietStat {
  label: string;
  count: number;
}

/** 饼图数据分片 */
interface PieSlice {
  label: string;
  value: number;
  color: string;
}

/** 图表内边距 */
interface PaddingRect {
  top: number;
  right: number;
  bottom: number;
  left: number;
}

// ===== 颜色常量 =====
const CHART_COLORS: string[] = [
  '#FF6B35', '#4ECDC4', '#FFD93D', '#6BCB77',
  '#FF8C5A', '#45B7D1', '#96CEB4', '#FFEAA7',
  '#D4A5A5', '#9B59B6', '#FF6B6B', '#48C9B0',
];

const CATEGORY_COLORS: string[] = [
  '#FFE8D0', // 家常清淡
  '#FFD0D0', // 重口过瘾
  '#D0FFE0', // 健康轻食
  '#D0E8FF', // 快餐速食
];

const CATEGORY_ACCENT_COLORS: string[] = [
  '#E8A060', // 家常清淡
  '#E86060', // 重口过瘾
  '#60C080', // 健康轻食
  '#60A0E0', // 快餐速食
];

@Entry
@Component
struct DietDashboard {
  @State showContent: boolean = false;
  @State isLoading: boolean = true;
  @State hasData: boolean = false;

  // 统计中间数据
  @State totalDecisions: number = 0;
  @State totalDishes: number = 0;
  @State uniqueDishes: number = 0;
  @State avgDishesPerDecision: number = 0;
  @State mostFreqCategory: string = '';
  @State mostFreqDish: string = '';

  // 图表数据
  @State categoryStats: CategoryStat[] = [];
  @State topDishes: DishCount[] = [];
  @State budgetStats: BudgetStat[] = [];
  @State timeStats: TimeStat[] = [];
  @State costTrend: CostTrendPoint[] = [];
  @State dietStats: DietStat[] = [];

  // Canvas 尺寸
  private pieSize: number = 220;
  private barHeight: number = 400;

  aboutToAppear(): void {
    animateTo({ duration: 500, curve: Curve.Smooth }, () => {
      this.showContent = true;
    });
  }

  onPageShow(): void {
    const context = getContext(this);
    this.loadData(context);
  }

  async loadData(context: common.Context): Promise<void> {
    this.isLoading = true;
    try {
      const records = await DbService.getAllDecisions(context);
      if (records.length === 0) {
        this.hasData = false;
        this.isLoading = false;
        return;
      }
      this.hasData = true;
      this.computeStats(records);
    } catch (error) {
      console.error('加载仪表盘数据失败：', JSON.stringify(error));
      this.hasData = false;
    } finally {
      this.isLoading = false;
    }
  }

  /**
   * 从决策记录中计算所有统计数据
   */
  computeStats(records: DecisionRecord[]): void {
    // 1. 解析所有记录中的菜品
    const allDishes: ParsedDish[] = [];
    const dishCountMap: Map<string, number> = new Map();
    const dishIconMap: Map<string, string> = new Map();
    const categoryCountMap: number[] = [0, 0, 0, 0];
    const budgetCountMap: Map<string, number> = new Map();
    const timeCountMap: Map<string, number> = new Map();
    const dietCountMap: Map<string, number> = new Map();
    const costByMonth: Map<string, number[]> = new Map();
    const categoryNames: string[] = ['家常清淡', '重口过瘾', '健康轻食', '快餐速食'];

    for (const record of records) {
      // 口味统计（按记录本身的 category）
      const catIdx = record.category;
      if (catIdx >= 0 && catIdx < 4) {
        categoryCountMap[catIdx]++;
      }

      // 预算偏好
      if (record.budgetLabel) {
        budgetCountMap.set(record.budgetLabel, (budgetCountMap.get(record.budgetLabel) || 0) + 1);
      }

      // 时间偏好
      if (record.timeLabel) {
        timeCountMap.set(record.timeLabel, (timeCountMap.get(record.timeLabel) || 0) + 1);
      }

      // 饮食限制统计（展开 dietLabels）
      if (record.dietLabels && record.dietLabels.length > 0) {
        for (const dl of record.dietLabels) {
          dietCountMap.set(dl, (dietCountMap.get(dl) || 0) + 1);
        }
      }

      // 解析 results 中的菜品
      try {
        const dishes: Array<Record<string, string>> = JSON.parse(record.results) as Array<Record<string, string>>;
        if (Array.isArray(dishes)) {
          for (const d of dishes) {
            const name = String(d['name'] || '');
            if (!name) continue;
            const cookedCost = Number(d['cookCost']) || 0;
            const dish: ParsedDish = {
              name: name,
              icon: String(d['icon'] || '🍽️'),
              cost: String(d['cost'] || '0'),
              cookCost: cookedCost,
              difficulty: String(d['difficulty'] || ''),
              category: record.category,
              categoryName: record.categoryName,
            };
            allDishes.push(dish);

            // 菜品频次统计
            dishCountMap.set(name, (dishCountMap.get(name) || 0) + 1);
            if (!dishIconMap.has(name)) {
              dishIconMap.set(name, dish.icon);
            }

            // 花费趋势（按月）
            if (cookedCost > 0) {
              const date = new Date(record.createdAt);
              const monthKey = `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}`;
              const costs = costByMonth.get(monthKey);
              if (costs) {
                costs.push(cookedCost);
              } else {
                costByMonth.set(monthKey, [cookedCost]);
              }
            }
          }
        }
      } catch (_unused) {
        // 解析失败跳过
      }
    }

    // 概览数据
    this.totalDecisions = records.length;
    this.totalDishes = allDishes.length;
    this.uniqueDishes = dishCountMap.size;
    this.avgDishesPerDecision = this.totalDecisions > 0
      ? Math.round((this.totalDishes / this.totalDecisions) * 10) / 10
      : 0;

    // 最常见口味
    let maxCatCount = 0;
    let maxCatIdx = 0;
    for (let i = 0; i < 4; i++) {
      if (categoryCountMap[i] > maxCatCount) {
        maxCatCount = categoryCountMap[i];
        maxCatIdx = i;
      }
    }
    this.mostFreqCategory = categoryNames[maxCatIdx];

    // 最常见菜品
    let maxDishCount = 0;
    let maxDishName = '';
    dishCountMap.forEach((cnt, name) => {
      if (cnt > maxDishCount) {
        maxDishCount = cnt;
        maxDishName = name;
      }
    });
    this.mostFreqDish = maxDishName;

    // 各口味占比
    this.categoryStats = categoryNames.map<CategoryStat>((name, idx) => ({
      name: name,
      count: categoryCountMap[idx],
      color: CATEGORY_ACCENT_COLORS[idx],
    }));

    // Top 10 菜品
    const sortedDishes: DishCount[] = [];
    dishCountMap.forEach((cnt, name) => {
      sortedDishes.push({ name: name, icon: dishIconMap.get(name) || '🍽️', count: cnt });
    });
    sortedDishes.sort((a, b) => b.count - a.count);
    this.topDishes = sortedDishes.slice(0, 10);

    // 预算偏好
    this.budgetStats = [];
    budgetCountMap.forEach((cnt, label) => {
      this.budgetStats.push({ label: label, count: cnt });
    });
    this.budgetStats.sort((a, b) => b.count - a.count);

    // 时间偏好
    this.timeStats = [];
    timeCountMap.forEach((cnt, label) => {
      this.timeStats.push({ label: label, count: cnt });
    });
    this.timeStats.sort((a, b) => b.count - a.count);

    // 花费趋势（按月）
    this.costTrend = [];
    const monthKeys: string[] = [];
    costByMonth.forEach((_costs, key) => {
      monthKeys.push(key);
    });
    monthKeys.sort();
    for (const monthKey of monthKeys) {
      const costs = costByMonth.get(monthKey);
      if (costs) {
        const avg = costs.reduce((s, c) => s + c, 0) / costs.length;
        const parts = monthKey.split('-');
        this.costTrend.push({
          label: `${parseInt(parts[1])}月`,
          avgCost: Math.round(avg * 10) / 10,
        });
      }
    }

    // 饮食限制统计
    this.dietStats = [];
    dietCountMap.forEach((cnt, label) => {
      this.dietStats.push({ label: label, count: cnt });
    });
    this.dietStats.sort((a, b) => b.count - a.count);
  }

  // ===== Canvas 绘图方法 =====

  /**
   * 绘制饼图
   */
  drawPieChart(canvas: CanvasRenderingContext2D, data: PieSlice[],
    cx: number, cy: number, radius: number): void {
    const total = data.reduce((s, d) => s + d.value, 0);
    if (total === 0) return;

    let startAngle = -Math.PI / 2;
    canvas.clearRect(0, 0, canvas.width, canvas.height);

    for (const item of data) {
      const sliceAngle = (item.value / total) * 2 * Math.PI;
      canvas.beginPath();
      canvas.moveTo(cx, cy);
      canvas.arc(cx, cy, radius, startAngle, startAngle + sliceAngle);
      canvas.closePath();
      canvas.fillStyle = item.color;
      canvas.fill();

      // 标注百分比
      const midAngle = startAngle + sliceAngle / 2;
      const labelR = radius * 0.65;
      const lx = cx + labelR * Math.cos(midAngle);
      const ly = cy + labelR * Math.sin(midAngle);
      const pct = Math.round((item.value / total) * 100);
      if (pct >= 5) {
        canvas.font = '18px sans-serif';
        canvas.fillStyle = '#FFFFFF';
        canvas.textAlign = 'center';
        canvas.textBaseline = 'middle';
        canvas.fillText(`${pct}%`, lx, ly);
      }

      startAngle += sliceAngle;
    }
  }

  /**
   * 绘制饼图图例（在右侧）
   */
  drawPieLegend(canvas: CanvasRenderingContext2D, data: PieSlice[],
    startX: number, startY: number, itemHeight: number, maxWidth: number): void {
    canvas.font = '18px sans-serif';
    const total = data.reduce((s, d) => s + d.value, 0);

    for (let i = 0; i < data.length; i++) {
      const y = startY + i * itemHeight;
      // 色块
      canvas.fillStyle = data[i].color;
      canvas.fillRect(startX, y, 12, 12);
      // 文字
      const pct = total > 0 ? Math.round((data[i].value / total) * 100) : 0;
      canvas.fillStyle = '#2D2D2D';
      canvas.textAlign = 'start';
      canvas.textBaseline = 'middle';
      const label = `${data[i].label} ${data[i].value}次(${pct}%)`;
      // 截断长文字
      const displayLabel = label.length > 14 ? label.substring(0, 13) + '..' : label;
      canvas.fillText(displayLabel, startX + 18, y + 6);
    }
  }

  /**
   * 绘制横向柱状图
   */
  drawHorizontalBarChart(canvas: CanvasRenderingContext2D,
    labels: string[], values: number[], colors: string[],
    chartX: number, chartY: number, barWidth: number, barGap: number,
    maxBarLen: number, title: string): void {
    canvas.clearRect(0, 0, canvas.width, canvas.height);

    let maxVal = 1;
    for (const v of values) {
      if (v > maxVal) maxVal = v;
    }
    const count = labels.length;

    // 标题
    canvas.font = '18px sans-serif';
    canvas.fillStyle = '#2D2D2D';
    canvas.textAlign = 'center';
    canvas.textBaseline = 'top';
    canvas.fillText(title, chartX + maxBarLen / 2, chartY - 32);

    // 画柱状条
    for (let i = 0; i < count; i++) {
      const y = chartY + i * (barWidth + barGap);
      const barLen = (values[i] / maxVal) * maxBarLen;

      // 排名数字
      canvas.font = '17px sans-serif';
      canvas.fillStyle = '#999999';
      canvas.textAlign = 'end';
      canvas.textBaseline = 'middle';
      canvas.fillText(`${i + 1}`, chartX - 8, y + barWidth / 2);

      // 柱体
      canvas.fillStyle = colors[i % colors.length];
      const radius = 6;
      if (barLen > 0) {
        canvas.beginPath();
        canvas.moveTo(chartX + radius, y + 2);
        canvas.lineTo(chartX + barLen - radius, y + 2);
        canvas.quadraticCurveTo(chartX + barLen, y + 2, chartX + barLen, y + barWidth / 2);
        canvas.quadraticCurveTo(chartX + barLen, y + barWidth - 2, chartX + barLen - radius, y + barWidth - 2);
        canvas.lineTo(chartX + radius, y + barWidth - 2);
        canvas.quadraticCurveTo(chartX, y + barWidth - 2, chartX, y + barWidth / 2);
        canvas.quadraticCurveTo(chartX, y + 2, chartX + radius, y + 2);
        canvas.closePath();
        canvas.fill();
      }

      // 菜品名（在柱体右侧或内部）
      canvas.font = '17px sans-serif';
      canvas.fillStyle = barLen > 80 ? '#FFFFFF' : '#2D2D2D';
      canvas.textAlign = barLen > 80 ? 'end' : 'start';
      canvas.textBaseline = 'middle';
      const textX = barLen > 80 ? chartX + barLen - 8 : chartX + barLen + 8;
      const displayName = labels[i].length > 8 ? labels[i].substring(0, 7) + '..' : labels[i];
      canvas.fillText(displayName, textX, y + barWidth / 2);

      // 数值标签
      canvas.font = '15px sans-serif';
      canvas.fillStyle = '#666666';
      canvas.textAlign = 'start';
      const textWidth: number = canvas.measureText(displayName).width || 0;
      if (barLen <= 80) {
        canvas.fillText(`${values[i]}次`, chartX + barLen + 8 + textWidth + 4, y + barWidth / 2);
      } else {
        canvas.fillText(`${values[i]}次`, chartX + 4, y + barWidth / 2);
      }
    }
  }

  /**
   * 绘制折线图（花费趋势）
   */
  drawLineChart(canvas: CanvasRenderingContext2D,
    data: CostTrendPoint[],
    chartX: number, chartY: number, chartW: number, chartH: number): void {
    canvas.clearRect(0, 0, canvas.width, canvas.height);

    if (data.length < 2) {
      canvas.font = '18px sans-serif';
      canvas.fillStyle = '#999999';
      canvas.textAlign = 'center';
      canvas.textBaseline = 'middle';
      canvas.fillText('数据不足，需要至少2个月的数据', canvas.width / 2, canvas.height / 2);
      return;
    }

    let maxCost = 1;
    for (const d of data) {
      if (d.avgCost > maxCost) maxCost = d.avgCost;
    }
    const padding: PaddingRect = { top: 30, right: 20, bottom: 40, left: 50 };
    const plotW = chartW - padding.left - padding.right;
    const plotH = chartH - padding.top - padding.bottom;
    const plotX = chartX + padding.left;
    const plotY = chartY + padding.top;

    // 标题
    canvas.font = '18px sans-serif';
    canvas.fillStyle = '#2D2D2D';
    canvas.textAlign = 'center';
    canvas.fillText('平均花费趋势', chartX + chartW / 2, chartY + 9);

    // Y轴
    canvas.strokeStyle = '#E0E0E0';
    canvas.lineWidth = 1;
    canvas.beginPath();
    canvas.moveTo(plotX, plotY);
    canvas.lineTo(plotX, plotY + plotH);
    canvas.stroke();

    // X轴
    canvas.beginPath();
    canvas.moveTo(plotX, plotY + plotH);
    canvas.lineTo(plotX + plotW, plotY + plotH);
    canvas.stroke();

    // Y轴刻度
    const ySteps = 4;
    canvas.font = '14px sans-serif';
    canvas.fillStyle = '#999999';
    canvas.textAlign = 'end';
    canvas.textBaseline = 'middle';
    for (let i = 0; i <= ySteps; i++) {
      const val = (maxCost / ySteps) * i;
      const y = plotY + plotH - (i / ySteps) * plotH;
      canvas.fillText(`¥${Math.round(val)}`, plotX - 8, y);
      // 横网格线
      canvas.strokeStyle = '#F0F0F0';
      canvas.lineWidth = 1;
      canvas.beginPath();
      canvas.moveTo(plotX, y);
      canvas.lineTo(plotX + plotW, y);
      canvas.stroke();
    }

    // X轴标签
    canvas.font = '15px sans-serif';
    canvas.fillStyle = '#666666';
    canvas.textAlign = 'center';
    canvas.textBaseline = 'top';
    const stepX = plotW / (data.length - 1);

    // 绘制折线
    canvas.strokeStyle = '#FF6B35';
    canvas.lineWidth = 3;
    canvas.beginPath();
    for (let i = 0; i < data.length; i++) {
      const x = plotX + i * stepX;
      const y = plotY + plotH - (data[i].avgCost / maxCost) * plotH;
      if (i === 0) {
        canvas.moveTo(x, y);
      } else {
        canvas.lineTo(x, y);
      }
    }
    canvas.stroke();

    // 绘制数据点
    for (let i = 0; i < data.length; i++) {
      const x = plotX + i * stepX;
      const y = plotY + plotH - (data[i].avgCost / maxCost) * plotH;

      canvas.fillStyle = '#FF6B35';
      canvas.beginPath();
      canvas.arc(x, y, 5, 0, 2 * Math.PI);
      canvas.fill();

      canvas.fillStyle = '#FFFFFF';
      canvas.beginPath();
      canvas.arc(x, y, 2.5, 0, 2 * Math.PI);
      canvas.fill();

      // 标签
      canvas.font = '15px sans-serif';
      canvas.fillStyle = '#2D2D2D';
      canvas.textAlign = 'center';
      canvas.textBaseline = 'bottom';
      canvas.fillText(`¥${data[i].avgCost}`, x, y - 10);

      // X轴刻度
      canvas.fillStyle = '#666666';
      canvas.textBaseline = 'top';
      canvas.fillText(data[i].label, x, plotY + plotH + 8);
    }
  }

  /**
   * 绘制纵向柱状图（预算、时间等）
   */
  drawVerticalBarChart(canvas: CanvasRenderingContext2D,
    labels: string[], values: number[], colors: string[],
    chartX: number, chartY: number, chartW: number, chartH: number,
    title: string): void {
    canvas.clearRect(0, 0, canvas.width, canvas.height);

    let maxVal = 1;
    for (const v of values) {
      if (v > maxVal) maxVal = v;
    }
    const padding: PaddingRect = { top: 30, right: 20, bottom: 40, left: 10 };
    const plotW = chartW - padding.left - padding.right;
    const plotH = chartH - padding.top - padding.bottom;
    const plotX = chartX + padding.left;
    const plotY = chartY + padding.top;

    // 标题
    canvas.font = '18px sans-serif';
    canvas.fillStyle = '#2D2D2D';
    canvas.textAlign = 'center';
    canvas.fillText(title, chartX + chartW / 2, chartY + 9);

    const barCount = labels.length;
    const barGap = 12;
    const barW = Math.min((plotW - barGap * (barCount + 1)) / barCount, 60);

    // 基线
    canvas.strokeStyle = '#E0E0E0';
    canvas.lineWidth = 1;
    canvas.beginPath();
    canvas.moveTo(plotX, plotY + plotH);
    canvas.lineTo(plotX + plotW, plotY + plotH);
    canvas.stroke();

    for (let i = 0; i < barCount; i++) {
      const x = plotX + barGap + i * (barW + barGap);
      const barH = (values[i] / maxVal) * plotH;
      const y = plotY + plotH - barH;

      // 柱体
      canvas.fillStyle = colors[i % colors.length];
      canvas.fillRect(x, y, barW, barH);

      // 数值
      canvas.font = '18px sans-serif';
      canvas.fillStyle = '#2D2D2D';
      canvas.textAlign = 'center';
      canvas.textBaseline = 'bottom';
      canvas.fillText(`${values[i]}次`, x + barW / 2, y - 6);

      // X轴标签
      canvas.fillStyle = '#666666';
      canvas.textBaseline = 'top';
      canvas.font = '15px sans-serif';
      canvas.fillText(labels[i], x + barW / 2, plotY + plotH + 8);
    }
  }

  build() {
    Stack() {
      Column() {
        // ===== 顶部导航 =====
        Row() {
          Text('←')
            .fontSize(22)
            .fontColor($r('app.color.text_primary'))
            .onClick(() => {
              router.back();
            })

          Blank()

          Text('我的饮食统计仪表盘')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary'))

          Blank()

          Text('  ')
            .fontSize(22)
        }
        .width('100%')
        .padding({ left: 20, right: 20, top: 16, bottom: 16 })
        .alignItems(VerticalAlign.Center)

        if (this.isLoading) {
          // 加载中
          Column() {
            LoadingProgress()
              .color($r('app.color.app_primary'))
              .width(40)
              .height(40)
            Text('正在分析你的饮食数据...')
              .fontSize(14)
              .fontColor($r('app.color.text_light'))
              .margin({ top: 16 })
          }
          .width('100%')
          .height('80%')
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
        } else if (!this.hasData) {
          // 无数据
          Column() {
            Text('📊')
              .fontSize(64)
            Text('暂无决策记录')
              .fontSize(18)
              .fontColor($r('app.color.text_secondary'))
              .margin({ top: 16 })
            Text('去推荐页面做一些决策，回来查看统计数据吧')
              .fontSize(14)
              .fontColor($r('app.color.text_light'))
              .margin({ top: 8 })
          }
          .width('100%')
          .height('80%')
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
        } else {
          // ===== 统计内容 =====
          Scroll() {
            Column() {
              // ===== 概览数据卡片 =====
              Text('📊 数据概览')
                .fontSize(17)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.text_primary'))
                .width('100%')
                .margin({ top: 16, bottom: 12 })
                .padding({ left: 24 })

              Row() {
                this.statCard('📋', '总决策次数', `${this.totalDecisions}次`)
                this.statCard('🍽️', '推荐菜品总数', `${this.totalDishes}道`)
              }
              .width('100%')
              .padding({ left: 16, right: 16 })

              Row() {
                this.statCard('🌟', '不同菜品数', `${this.uniqueDishes}道`)
                this.statCard('📈', '次均推荐', `${this.avgDishesPerDecision}道/次`)
              }
              .width('100%')
              .padding({ left: 16, right: 16 })
              .margin({ top: 8 })

              Row() {
                this.statCard('🏆', '最爱口味', this.mostFreqCategory)
                this.statCard('🥇', '最爱菜品', this.mostFreqDish.length > 8 ? this.mostFreqDish.substring(0, 7) + '..' : this.mostFreqDish)
              }
              .width('100%')
              .padding({ left: 16, right: 16 })
              .margin({ top: 8 })

              // ===== 各口味占比（饼图） =====
              if (this.categoryStats.length > 0) {
                Column() {
                  Text('🎨 各口味占比')
                    .fontSize(17)
                    .fontWeight(FontWeight.Bold)
                    .fontColor($r('app.color.text_primary'))
                    .width('100%')
                    .margin({ bottom: 12 })
                    .padding({ left: 8 })

                  Row() {
                    // 饼图（居中）
                    Canvas(this.pieCtx)
                      .width(this.pieSize)
                      .height(this.pieSize)
                      .onReady(() => {
                        const data: PieSlice[] = this.categoryStats.map<PieSlice>(s => ({
                          label: s.name,
                          value: s.count,
                          color: s.color,
                        }));
                        this.drawPieChart(this.pieCtx, data, this.pieSize / 2, this.pieSize / 2, this.pieSize / 2 - 10);
                      })
                  }
                  .width('100%')
                  .justifyContent(FlexAlign.Center)

                  // 图例列表（文字形式）
                  Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Start }) {
                    ForEach(this.categoryStats, (item: CategoryStat, index: number | undefined) => {
                      Row() {
                        Row()
                          .width(10)
                          .height(10)
                          .borderRadius(2)
                          .backgroundColor(item.color)
                          .margin({ right: 6 })
                        Text(`${item.name}: ${item.count}次`)
                          .fontSize(13)
                          .fontColor($r('app.color.text_secondary'))
                      }
                      .margin({ right: 16, bottom: 8 })
                    })
                  }
                  .width('100%')
                  .padding({ left: 8, top: 8 })
                }
                .width('100%')
                .backgroundColor($r('app.color.card_bg'))
                .borderRadius(16)
                .padding(16)
                .margin({ left: 16, right: 16, top: 16 })
              }

              // ===== 最常选的菜 Top 10（横向柱状图） =====
              if (this.topDishes.length > 0) {
                Column() {
                  Text('🏆 最常选的菜 Top 10')
                    .fontSize(17)
                    .fontWeight(FontWeight.Bold)
                    .fontColor($r('app.color.text_primary'))
                    .width('100%')
                    .margin({ bottom: 8 })
                    .padding({ left: 8 })

                  Canvas(this.topDishCtx)
                    .width('100%')
                    .height(this.topDishes.length * 44 + 50)
                    .onReady(() => {
                      const labels = this.topDishes.map(d => d.icon + ' ' + d.name);
                      const values = this.topDishes.map(d => d.count);
                      this.drawHorizontalBarChart(
                        this.topDishCtx, labels, values, CHART_COLORS,
                        30, 40, 32, 10, this.topDishCtx.width - 100, ''
                      );
                    })
                }
                .width('100%')
                .backgroundColor($r('app.color.card_bg'))
                .borderRadius(16)
                .padding(16)
                .margin({ left: 16, right: 16, top: 16 })
              }

              // ===== 平均花费趋势（折线图） =====
              if (this.costTrend.length > 0) {
                Column() {
                  Text('💰 平均花费趋势')
                    .fontSize(17)
                    .fontWeight(FontWeight.Bold)
                    .fontColor($r('app.color.text_primary'))
                    .width('100%')
                    .margin({ bottom: 8 })
                    .padding({ left: 8 })

                  Canvas(this.costTrendCtx)
                    .width('100%')
                    .height(240)
                    .onReady(() => {
                      this.drawLineChart(this.costTrendCtx,
                        this.costTrend,
                        0, 0, this.costTrendCtx.width, 240);
                    })

                  Text('注：花费为推荐菜品中"自己做"的平均成本')
                    .fontSize(12)
                    .fontColor($r('app.color.text_light'))
                    .width('100%')
                    .margin({ top: 4 })
                    .padding({ left: 8 })
                }
                .width('100%')
                .backgroundColor($r('app.color.card_bg'))
                .borderRadius(16)
                .padding(16)
                .margin({ left: 16, right: 16, top: 16 })
              }

              // ===== 时间偏好分布（饼图） =====
              if (this.timeStats.length > 0) {
                Column() {
                  Text('⏰ 时间偏好分布')
                    .fontSize(17)
                    .fontWeight(FontWeight.Bold)
                    .fontColor($r('app.color.text_primary'))
                    .width('100%')
                    .margin({ bottom: 12 })
                    .padding({ left: 8 })

                  Row() {
                    Canvas(this.timePieCtx)
                      .width(this.pieSize)
                      .height(this.pieSize)
                      .onReady(() => {
                        const data: PieSlice[] = this.timeStats.map<PieSlice>((s, idx) => ({
                          label: s.label,
                          value: s.count,
                          color: CHART_COLORS[idx % CHART_COLORS.length],
                        }));
                        this.drawPieChart(this.timePieCtx, data, this.pieSize / 2, this.pieSize / 2, this.pieSize / 2 - 10);
                      })
                  }
                  .width('100%')
                  .justifyContent(FlexAlign.Center)

                  Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Start }) {
                    ForEach(this.timeStats, (item: TimeStat, index: number | undefined) => {
                      Row() {
                        Row()
                          .width(10)
                          .height(10)
                          .borderRadius(2)
                          .backgroundColor(CHART_COLORS[(index as number) % CHART_COLORS.length])
                          .margin({ right: 6 })
                        Text(`${item.label}: ${item.count}次`)
                          .fontSize(13)
                          .fontColor($r('app.color.text_secondary'))
                      }
                      .margin({ right: 16, bottom: 8 })
                    })
                  }
                  .width('100%')
                  .padding({ left: 8, top: 8 })
                }
                .width('100%')
                .backgroundColor($r('app.color.card_bg'))
                .borderRadius(16)
                .padding(16)
                .margin({ left: 16, right: 16, top: 16 })
              }

              // ===== 预算偏好分布（柱状图） =====
              if (this.budgetStats.length > 0) {
                Column() {
                  Text('💵 预算偏好分布')
                    .fontSize(17)
                    .fontWeight(FontWeight.Bold)
                    .fontColor($r('app.color.text_primary'))
                    .width('100%')
                    .margin({ bottom: 8 })
                    .padding({ left: 8 })

                  Canvas(this.budgetCtx)
                    .width('100%')
                    .height(220)
                    .onReady(() => {
                      const labels = this.budgetStats.map(s => s.label);
                      const values = this.budgetStats.map(s => s.count);
                      this.drawVerticalBarChart(
                        this.budgetCtx, labels, values, CHART_COLORS,
                        0, 0, this.budgetCtx.width, 220,
                        ''
                      );
                    })
                }
                .width('100%')
                .backgroundColor($r('app.color.card_bg'))
                .borderRadius(16)
                .padding(16)
                .margin({ left: 16, right: 16, top: 16 })
              }

              // ===== 饮食限制统计 =====
              if (this.dietStats.length > 0) {
                Column() {
                  Text('🚫 饮食限制统计')
                    .fontSize(17)
                    .fontWeight(FontWeight.Bold)
                    .fontColor($r('app.color.text_primary'))
                    .width('100%')
                    .margin({ bottom: 12 })
                    .padding({ left: 8 })

                  Column() {
                    ForEach(this.dietStats, (item: DietStat) => {
                      Row() {
                        Text(this.dietIconMap(item.label))
                          .fontSize(20)
                          .margin({ right: 12 })

                        Column() {
                          Text(item.label)
                            .fontSize(15)
                            .fontColor($r('app.color.text_primary'))
                            .fontWeight(FontWeight.Medium)

                          Row() {
                            // 进度条
                            Row()
                              .width(`${Math.min(100, Math.round((item.count / this.dietStats[0].count) * 100))}%`)
                              .height(8)
                              .backgroundColor($r('app.color.app_primary'))
                              .borderRadius(4)

                            Text(`${item.count}次`)
                              .fontSize(13)
                              .fontColor($r('app.color.text_light'))
                              .margin({ left: 8 })
                          }
                          .width('100%')
                          .margin({ top: 6 })
                        }
                        .layoutWeight(1)
                        .alignItems(HorizontalAlign.Start)
                      }
                      .width('100%')
                      .padding({ top: 8, bottom: 8 })
                      .borderRadius(8)
                    })
                  }
                  .width('100%')
                  .padding({ left: 8, right: 8 })
                }
                .width('100%')
                .backgroundColor($r('app.color.card_bg'))
                .borderRadius(16)
                .padding(16)
                .margin({ left: 16, right: 16, top: 16, bottom: 32 })
              }

            }
            .width('100%')
          }
          .edgeEffect(EdgeEffect.Spring)
          .width('100%')
          .backgroundColor($r('app.color.app_bg'))
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor($r('app.color.app_bg'))
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    }
    .width('100%')
    .height('100%')
  }

  // ===== Canvas 上下文 =====
  private pieCtx: CanvasRenderingContext2D = new CanvasRenderingContext2D();
  private timePieCtx: CanvasRenderingContext2D = new CanvasRenderingContext2D();
  private topDishCtx: CanvasRenderingContext2D = new CanvasRenderingContext2D();
  private costTrendCtx: CanvasRenderingContext2D = new CanvasRenderingContext2D();
  private budgetCtx: CanvasRenderingContext2D = new CanvasRenderingContext2D();

  // ===== 饮食限制图标映射 =====
  dietIconMap(label: string): string {
    if (label.includes('辣')) return '🌶️';
    if (label.includes('香菜')) return '🌿';
    if (label.includes('海鲜')) return '🦐';
    if (label.includes('素食')) return '🥬';
    return '🚫';
  }

  // ===== 统计卡片 =====
  @Builder
  statCard(icon: string, label: string, value: string) {
    Column() {
      Text(icon)
        .fontSize(28)
      Text(value)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary'))
        .margin({ top: 8 })
      Text(label)
        .fontSize(13)
        .fontColor($r('app.color.text_light'))
        .margin({ top: 4 })
    }
    .width('48%')
    .alignItems(HorizontalAlign.Center)
    .backgroundColor($r('app.color.card_bg'))
    .borderRadius(16)
    .padding(16)
    .shadow({ radius: 4, color: '#10000000', offsetY: 2 })
  }
}
