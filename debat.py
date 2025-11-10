import os, re

def set_env(line):
    # 1. 先查找 @set '=
    # 2. 再查找 &@ 结束符
    sindex = line.rfind("@set '=")
    if sindex == -1: return
    eindex = line.find('&@', sindex + 7)
    if eindex == -1: return
    var_value = line[sindex + 7:eindex]
    var_value = var_value.replace('^^^', '^')
    os.environ["'"] = var_value
    print(f">>> '{var_value}'")


def main():
    # 读取文件内容
    fin  = open("FEC4_DEBUG.bat", "r", encoding="gbk")
    content = fin.read()
    fin.close()

    # 1 set '=^^^I^^^<^^^6n^^^K^^^0h^^^\^^^C^^^8xk^^^]^^^S^^^?^^^(^^^D^^^O^^^;j^^^3^^^7r^^^=y^^^.^^^#d^^^)^^^[u^^^4^^^H^^^2^^^L^^^W^^^Xo^^^/^^^1^^^N^^^G^^^_^^^U^^^9^^^+^^^{b^^^`q^^^5^^^-^^^Me^^^ tw^^^&^^^E^^^Z^^^Y^^^}^^^Ap^^^^gz^^^:^^^F^^^J^^^,a^^^|^^^"lf^^^*^^^Vm^^^P^^^$^^^@sv^^^~c^^^R^^^Q^^^B^^^T^^^'^^^>i
    # 2 set '=^^^Uj^^^Vyq^^^H^^^Tkrv^^^?^^^;^^^F^^^2l^^^0^^^-^^^M^^^"^^^A^^^1^^^\^^^ ^^^W^^^/p^^^+w^^^Kund^^^<^^^R^^^@^^^*s^^^E^^^^^^^=h^^^,^^^O^^^Yz^^^S^^^Zx^^^~^^^Xo^^^{^^^N^^^I^^^L^^^6^^^7^^^Q^^^]^^^J^^^P^^^D^^^8^^^'i^^^.^^^)g^^^&^^^Gatm^^^4e^^^B^^^_^^^5^^^3^^^`^^^C^^^:^^^|f^^^9^^^$c^^^#^^^(^^^[^^^>^^^}b
    # 3 set '=h^^^(^^^.^^^Jga^^^N^^^D^^^"t^^^5^^^1^^^;l^^^L^^^R^^^}^^^3w^^^Z^^^I^^^Hu^^^`d^^^E^^^X^^^_i^^^B^^^@^^^[y^^^?e^^^)^^^C^^^2^^^V^^^:^^^/^^^'^^^P^^^Y^^^$^^^~b^^^Gsr^^^>^^^+^^^9^^^U^^^&^^^Qq^^^\^^^K^^^*x^^^<z^^^^k^^^4^^^A^^^F^^^Sj^^^]f^^^|om^^^Wc^^^O^^^M^^^0n^^^,^^^{^^^#p^^^=^^^8^^^Tv^^^6^^^-^^^7^^^ 
    # 4 set '=^^^U^^^B^^^=^^^0cbe^^^D^^^Ng^^^)^^^M^^^:^^^8v^^^>^^^1pk^^^ ^^^_^^^Aa^^^C^^^~^^^Q^^^5hu^^^|^^^J^^^?y^^^<^^^V^^^F^^^#^^^]j^^^S^^^P^^^W^^^&m^^^.^^^Zi^^^[^^^$o^^^Y^^^}^^^I^^^X^^^-^^^Grqdt^^^Rzs^^^+^^^T^^^6^^^`^^^Ef^^^"^^^(^^^/^^^7^^^L^^^\x^^^3^^^,w^^^H^^^O^^^'^^^2^^^^l^^^4^^^*^^^{^^^@^^^K^^^9n^^^;
    # 5 set '=b^^^Z^^^=i^^^-^^^Pfok^^^^^^^M^^^H^^^Amv^^^6^^^/^^^ ^^^*^^^N^^^Ul^^^3t^^^D^^^2^^^`^^^(^^^E^^^5^^^Y^^^4^^^G^^^9^^^.^^^~^^^,^^^#^^^Te^^^_p^^^&^^^"s^^^)^^^B^^^{rnquy^^^I^^^>^^^'x^^^8^^^J^^^S^^^$w^^^|^^^:j^^^K^^^]h^^^\^^^}^^^;^^^@^^^7^^^1^^^0a^^^?g^^^+d^^^<^^^F^^^L^^^X^^^[^^^Q^^^Oz^^^R^^^Cc^^^W^^^V
    # 6 set '=^^^}^^^+^^^Xd^^^2^^^_^^^C^^^<^^^U^^^;^^^,^^^O^^^>^^^T^^^'^^^{^^^1^^^.rob^^^Q^^^Yj^^^"^^^Ic^^^G^^^^^^^[^^^L^^^$k^^^(^^^#^^^S^^^0^^^)^^^V^^^6^^^Dzey^^^P^^^B^^^&^^^H^^^5^^^E^^^K^^^|v^^^*^^^9l^^^~s^^^]^^^Mw^^^ ^^^N^^^:^^^4qi^^^F^^^@^^^\m^^^3p^^^-t^^^W^^^/a^^^=^^^`^^^Ah^^^Jxfg^^^7^^^Zu^^^?^^^Rn^^^8
    # 7 set '=^^^)qhpv^^^D^^^V^^^Y^^^0s^^^Q^^^7^^^`^^^M^^^*^^^.^^^Z^^^C^^^Toz^^^#w^^^G^^^{lci^^^1^^^^^^^&m^^^:^^^X^^^E^^^[^^^Na^^^L^^^4e^^^~^^^Hb^^^$^^^|x^^^B^^^K^^^P^^^5^^^_^^^8^^^}k^^^A^^^R^^^\^^^(^^^?r^^^3^^^J^^^,^^^9^^^Fgu^^^ ^^^2^^^'^^^I^^^+^^^]^^^O^^^U^^^;d^^^6^^^"^^^-n^^^@^^^/^^^<^^^W^^^>tf^^^=y^^^Sj
    # 8 set '=a^^^_^^^Zp^^^.^^^;^^^Oi^^^\^^^7^^^[^^^,^^^X^^^1^^^`^^^ ze^^^2^^^T^^^?^^^:f^^^-x^^^&^^^N^^^3^^^+^^^H^^^J^^^C^^^I^^^^u^^^M^^^R^^^E^^^/m^^^Bb^^^'^^^S^^^@^^^Yg^^^(j^^^|^^^=^^^"^^^{^^^L^^^>^^^8^^^K^^^P^^^*^^^5cwt^^^~^^^6v^^^G^^^$l^^^9^^^4y^^^Qrnh^^^Uk^^^<o^^^W^^^]^^^)^^^#^^^}s^^^D^^^Fq^^^Ad^^^0^^^V
    #       r"""^I^<^6n^K^0h^\^C^8xk^]^S^?^(^D^O^;j^3^7r^=y^.^#d^)^[u^4^H^2^L^W^Xo^/^1^N^G^_^U^9^+^{b^`q^5^-^Me^ tw^&^E^Z^Y^}^Ap^^gz^:^F^J^,a^|^"lf^*^Vm^P^$^@sv^~c^R^Q^B^T^'^>i"""
    #       r"""^Uj^Vyq^H^Tkrv^?^;^F^2l^0^-^M^"^A^1^\^ ^W^/p^+w^Kund^<^R^@^*s^E^^^=h^,^O^Yz^S^Zx^~^Xo^{^N^I^L^6^7^Q^]^J^P^D^8^'i^.^)g^&^Gatm^4e^B^_^5^3^`^C^:^|f^9^$c^#^(^[^>^}b"""
    #       r"""h^(^.^Jga^N^D^"t^5^1^;l^L^R^}^3w^Z^I^Hu^`d^E^X^_i^B^@^[y^?e^)^C^2^V^:^/^'^P^Y^$^~b^Gsr^>^+^9^U^&^Qq^\^K^*x^<z^^k^4^A^F^Sj^]f^|om^Wc^O^M^0n^,^{^#p^=^8^Tv^6^-^7^ """
    #       r"""^U^B^=^0cbe^D^Ng^)^M^:^8v^>^1pk^ ^_^Aa^C^~^Q^5hu^|^J^?y^<^V^F^#^]j^S^P^W^&m^.^Zi^[^$o^Y^}^I^X^-^Grqdt^Rzs^+^T^6^`^Ef^"^(^/^7^L^\x^3^,w^H^O^'^2^^l^4^*^{^@^K^9n^;"""
    #       r"""b^Z^=i^-^Pfok^^^M^H^Amv^6^/^ ^*^N^Ul^3t^D^2^`^(^E^5^Y^4^G^9^.^~^,^#^Te^_p^&^"s^)^B^{rnquy^I^>^'x^8^J^S^$w^|^:j^K^]h^\^}^;^@^7^1^0a^?g^+d^<^F^L^X^[^Q^Oz^R^Cc^W^V"""
    #       r"""^}^+^Xd^2^_^C^<^U^;^,^O^>^T^'^{^1^.rob^Q^Yj^"^Ic^G^^^[^L^$k^(^#^S^0^)^V^6^Dzey^P^B^&^H^5^E^K^|v^*^9l^~s^]^Mw^ ^N^:^4qi^F^@^\m^3p^-t^W^/a^=^`^Ah^Jxfg^7^Zu^?^Rn^8"""
    #       r"""^)qhpv^D^V^Y^0s^Q^7^`^M^*^.^Z^C^Toz^#w^G^{lci^1^^^&m^:^X^E^[^Na^L^4e^~^Hb^$^|x^B^K^P^5^_^8^}k^A^R^\^(^?r^3^J^,^9^Fgu^ ^2^'^I^+^]^O^U^;d^6^"^-n^@^/^<^W^>tf^=y^Sj"""
    #       r"""^0^5^F^O^@g^2^^o^A^"^}^N^_^?n^V^(^{^`^=^8^#^4^Y^R^~^W^$z^Glhf^-^.w^E^Mui^L^S^[^P^*b^>^]^Q^3s^/^C^9^6^)^'x^U^K^;^B^X^Z^1^\k^|^,v^7c^D^Trtpqy^<^:d^J^ ma^Ie^+^&^Hj"""
    #       r"""a^_^Zp^.^;^Oi^\^7^[^,^X^1^`^ ze^2^T^?^:f^-x^&^N^3^+^H^J^C^I^^u^M^R^E^/m^Bb^'^S^@^Yg^(j^|^=^"^{^L^>^8^K^P^*^5cwt^~^6v^G^$l^9^4y^Qrnh^Uk^<o^W^]^)^#^}s^D^Fq^Ad^0^V"""
    # os.environ["'"] = r"""^I^<^6n^K^0h^\^C^8xk^]^S^?^(^D^O^;j^3^7r^=y^.^#d^)^[u^4^H^2^L^W^Xo^/^1^N^G^_^U^9^+^{b^`q^5^-^Me^ tw^&^E^Z^Y^}^Ap^^gz^:^F^J^,a^|^"lf^*^Vm^P^$^@sv^~c^R^Q^B^T^'^>i"""
    # os.environ["'"] = r"""^Uj^Vyq^H^Tkrv^?^;^F^2l^0^-^M^"^A^1^\^ ^W^/p^+w^Kund^<^R^@^*s^E^^^=h^,^O^Yz^S^Zx^~^Xo^{^N^I^L^6^7^Q^]^J^P^D^8^'i^.^)g^&^Gatm^4e^B^_^5^3^`^C^:^|f^9^$c^#^(^[^>^}b"""
    # os.environ["'"] = r"""h^(^.^Jga^N^D^"t^5^1^;l^L^R^}^3w^Z^I^Hu^`d^E^X^_i^B^@^[y^?e^)^C^2^V^:^/^'^P^Y^$^~b^Gsr^>^+^9^U^&^Qq^\^K^*x^<z^^k^4^A^F^Sj^]f^|om^Wc^O^M^0n^,^{^#p^=^8^Tv^6^-^7^ """
    # os.environ["'"] = r"""^U^B^=^0cbe^D^Ng^)^M^:^8v^>^1pk^ ^_^Aa^C^~^Q^5hu^|^J^?y^<^V^F^#^]j^S^P^W^&m^.^Zi^[^$o^Y^}^I^X^-^Grqdt^Rzs^+^T^6^`^Ef^"^(^/^7^L^\x^3^,w^H^O^'^2^^l^4^*^{^@^K^9n^;"""
    # os.environ["'"] = r"""b^Z^=i^-^Pfok^^^M^H^Amv^6^/^ ^*^N^Ul^3t^D^2^`^(^E^5^Y^4^G^9^.^~^,^#^Te^_p^&^"s^)^B^{rnquy^I^>^'x^8^J^S^$w^|^:j^K^]h^\^}^;^@^7^1^0a^?g^+d^<^F^L^X^[^Q^Oz^R^Cc^W^V"""
    # os.environ["'"] = r"""^}^+^Xd^2^_^C^<^U^;^,^O^>^T^'^{^1^.rob^Q^Yj^"^Ic^G^^^[^L^$k^(^#^S^0^)^V^6^Dzey^P^B^&^H^5^E^K^|v^*^9l^~s^]^Mw^ ^N^:^4qi^F^@^\m^3p^-t^W^/a^=^`^Ah^Jxfg^7^Zu^?^Rn^8"""
    # os.environ["'"] = r"""^)qhpv^D^V^Y^0s^Q^7^`^M^*^.^Z^C^Toz^#w^G^{lci^1^^^&m^:^X^E^[^Na^L^4e^~^Hb^$^|x^B^K^P^5^_^8^}k^A^R^\^(^?r^3^J^,^9^Fgu^ ^2^'^I^+^]^O^U^;d^6^"^-n^@^/^<^W^>tf^=y^Sj"""
    # os.environ["'"] = r"""^0^5^F^O^@g^2^^o^A^"^}^N^_^?n^V^(^{^`^=^8^#^4^Y^R^~^W^$z^Glhf^-^.w^E^Mui^L^S^[^P^*b^>^]^Q^3s^/^C^9^6^)^'x^U^K^;^B^X^Z^1^\k^|^,v^7c^D^Trtpqy^<^:d^J^ ma^Ie^+^&^Hj"""
    # os.environ["'"] = r"""a^_^Zp^.^;^Oi^\^7^[^,^X^1^`^ ze^2^T^?^:f^-x^&^N^3^+^H^J^C^I^^u^M^R^E^/m^Bb^'^S^@^Yg^(j^|^=^"^{^L^>^8^K^P^*^5cwt^~^6v^G^$l^9^4y^Qrnh^Uk^<o^W^]^)^#^}s^D^Fq^Ad^0^V"""

    result = ""
    linenum = 0
    for line in content.splitlines():
        linenum = linenum + 1
        pattern = r"%([\w']+):~([-]?\d+),(\d+)%"
        matches = re.findall(pattern, line)
        for match in matches:
            var_name, startstr, length = match
            var_value = os.getenv(var_name, "")
            if var_value == "": continue
            # 
            start = int(startstr)
            length = int(length)
            if start < 0: start = len(var_value) + start
            subvalue = var_value[start:start+length]
            # print(f"{linenum}: %{var_name}:~{startstr},{length}% >>> '{subvalue}'")
            # 替换原内容
            oldstr = f"%{var_name}:~{startstr},{length}%"
            newstr = subvalue
            line = line.replace(oldstr, newstr)
        result = result + line + '\n'
        set_env(line)
        
    # 写回文件
    fout = open("FEC4_DEBUG_OK.bat", "w", encoding="gbk")
    fout.write(result)

    '''


    # 正则表达式 %(\w+):~([-]?\d+),(\d+a)%
    pattern = r'%(\w+):~([-]?\d+),(\d+)%'
    matches = re.findall(pattern, content)
    num = 0
    for match in matches:
        num = num + 1
        var_name, startstr, length = match
        var_value = os.getenv(var_name, "")
        start = int(startstr)
        length = int(length)
        if start < 0: start = len(var_value) + start
        subvalue = var_value[start:start+length]
        print(f"{num}: %{var_name}:~{startstr},{length}% >>> '{subvalue}'")
        # 替换原内容
        oldstr = f"%{var_name}:~{startstr},{length}%"
        newstr = subvalue
        content = content.replace(oldstr, newstr)
    # 写回文件
    fout = open("FEC4_DEBUG_OK.bat", "w", encoding="gbk")
    fout.write(content)
    '''


if __name__ == "__main__":
    main()