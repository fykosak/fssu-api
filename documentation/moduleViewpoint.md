# Tex #
- obsluhuje requesty které něco texají
- seznam probíhajících jobů, může je abortovat
    - job je identifikován souborem a uživatelem, když přijde nový, abortne se starý
- před tím napíše **Login File System**, aby si updatnul soubory
- joby texají přímo v **LFS**

# Login File System #
- každý login má u něj jednu složku
- v ní jsou složky pro každý existující problem (podle jeho ID) plus složka pro jeden návrh
- může tam jako jediný přímo zapisovat (kromě texového procesu)
- update složky:
    - podívá se do DB pro všechny závislosti
    - podívá se, jestli má nejnovější verze, a pokud ne, nakopíruje si je
    - od **Competition** si zjistí potřebné věci pro texání (Makefile pro daný mód)
- udržuje si teda seznam souborů s timestampy
- update proběhne se zámky

# Competition #
- GetMakefileForProblem(problem.id, mode)
    - vrátí Makefile pro danou úlohu specificky podle zvoleného módu (např. jaký jazyk chceme)
    - z problem.id najde competition.id a z toho zjistí kde je soubor
- GetMakefileForImage(image.id, mode)
    - z image.id se najde problem.id (každý obrázek může být jen pro jednu úlohus)

# Lock #
- při otevření úlohy, obrázku nebo datového souboru k úpravu se na tom vyrobí zámek na daný login
- toto kontroluje, že jen ten login to může upravovat
- pokud bude dlouho neaktivní, smaže mu zámek