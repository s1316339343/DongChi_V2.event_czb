import zipfile, re, traceback
NL = chr(10)
try:
    z = zipfile.ZipFile(r'D:\codeProject\DongChi_V2.0.0\模板_tmp.docx')
    xml = z.read('word/document.xml').decode('utf-8')
    rels = z.read('word/_rels/document.xml.rels').decode('utf-8')
    relmap = dict(re.findall(r'Id="(rId\d+)"[^>]*Target="([^"]+)"', rels))
    def unesc(s):
        for a,b in (('&amp;','&'),('&lt;','<'),('&gt;','>'),('&quot;','"'),('&apos;',"'")):
            s = s.replace(a,b)
        return s
    paras = re.findall(r'<w:p[ >].*?</w:p>', xml, re.S)
    lines = ['PARA_COUNT %d' % len(paras)]
    for p in paras:
        imgs = re.findall(r'r:embed="(rId\d+)"', p)
        imgtxt = ' [IMG:' + ' | '.join(relmap.get(i,i) for i in imgs) + ']' if imgs else ''
        texts = re.findall(r'<w:t[^>]*>(.*?)</w:t>', p, re.S)
        lines.append(''.join(unesc(t) for t in texts) + imgtxt)
    try:
        cx = z.read('word/comments.xml').decode('utf-8')
        comments = re.findall(r'<w:comment [^>]*w:author="([^"]*)"[^>]*>(.*?)</w:comment>', cx, re.S)
        lines.append('===== COMMENTS =====')
        for author, body in comments:
            texts = re.findall(r'<w:t[^>]*>(.*?)</w:t>', body, re.S)
            lines.append('[%s]: %s' % (author, ''.join(unesc(t) for t in texts)))
    except KeyError:
        pass
    with open(r'D:\codeProject\DongChi_V2.0.0\_tmp_docx_out.txt','w',encoding='utf-8') as f:
        f.write(NL.join(lines))
except Exception:
    with open(r'D:\codeProject\DongChi_V2.0.0\_tmp_docx_out.txt','w',encoding='utf-8') as f:
        f.write(traceback.format_exc())
