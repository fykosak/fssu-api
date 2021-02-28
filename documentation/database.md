# Úvod
Schéma databáze se dělí na několik částí.
- V centru se nachází třída **Problem**, na který se napojuje téměř všechno ostatní.
- Vlevo je jsou třídy pro organizátory a práva (dále rozdělení na FYKOS/VÝFUK/...).
- Nahoře je uspořádání úloh do soutěží (Seminář, FOL, FOF, ...).
- Vpravo uprostřed jsou obrázky a grafy.
- Dole uprostřed je většina maker, které úloha obsahuje. Dále tu je workflow.
- Třídy pro makra, obrázky a workflow se verzují, což znamená, že od každé existuje tabulka s historií všech verzí. Každá verze je popsána pomocí **Action**, která se společně s komentáři nachází vpravo dole.

# Úloha
## Třídy ##
### Problem ###
- Reprezentuje jednu úlohu v systému.
- Ať je vybrána (nebo právě vybírána) do jakékoli soutěže, má kolik chce verzí a korektur, vždy je reprezentována jen jedním záznamem v této tabulce.
- *Solvers*, *Avg* - počet řešitelů a průměrný počet bodů (makra \probsolvers a \probavg).
- *Batch*, *No* - série resp. pořadí úlohy v sérii. U FOLu je místo sérií hurry-up, u FOFu je všechno v první sérii.

# Práva a organizátoři
## Třídy ##
### Login ###
- Základní jednotka, na kterou se váží práva, organizátoři a historie úprav.
- *Email*, *Password* - přihlašovací údaje do systému (a na kopání).

### Group ###
- Definuje jednu oddělenou skupinu - cokoli (úlohy, soutěže) patří do jedné skupiny, nemůže nijak ovlivňovat nic v jiných skupinách.
- Každý **Login** může vidět jen věci z té skupiny, ke které má přístup.
- Např. jedna skupina bude pro FYKOS, další pro VÝFUK.
- *Name* - unikátní název

### Organizer ###
- Organizátor, který vystupuje ve **Workflow** (někdo, kdo napsal vzorák, někdo, kdo vyrobil korekturu ...).
- *Name* - jméno
- Organizátor nebude mít email, protože nejde jen tak kopat někoho, kdo není v systému.
- *Language* - výchozí jazyk - např. u slováků se vytvoří potřeba překladu zadání a tak

## Vztahy ##
### LoginInGroup ###
- Login je ve skupině a má tedy práva na přístup k jejím úlohám a soutěžím.
- Jeden login může být v libovolně mnoho skupinách, stejně jako v každé skupině může být libovolně mnoho loginů.

### OrganizerInGroup ###
- Jde o to, že organizátor musí mít unikátní *TexAlias* pouze v rámci jedné skupiny
- *TexAlias* - používá se v makrech \probauthors a \probsolauthors.

### OrganizerLogin ###
- Organizátor má přihlašovací údaje.
- Může mít maximálně jedny, ale každé údaje musí být přiřazeny k nějakému organizátorovi.

# Soutěže
## Třídy ##
### Directory ###
Složka s úlohami - může to být jak soutěž, tak složka s návrhy / trash. Úloha je vždy v právě jedné **Directory**.
- *Name* - název, který se zobrazí v klientu při popisu složky.
- *Path* - cesta do složky se vším potřebným k texání.

### Competition ###
- Jeden ročník soutěže typu seminář, FOL, FOF.
- *Name* - oficiální název (např. Fyziklání Online 2021), neplést s *Name* třídy **Directory**.
- *Year* - ročník.
- *TexCode* - makro \probsource.
- *Type* - druh soutěže, např. seminář, FOL, FOF.
- *Status* - něco jako ještě nic / výběr / probíhající soutěž / ukončeno.

### Draftset ###
Složka s návrhy na úlohy, nebo obecně jiná složka (např. trash).

### DraftHistory ###
- Značí, že úloha se nacházela/nachází v nějakém draftsetu.
- *Cathegory*, *Batch*, *No* - kategorie, série a číslo, do kterých je úloha navržena. Nejsou povinné (záleží na soutěži).

### Evaluation ###
- Hodnocení úlohy v rámci návrhu do soutěže - úloha může být hodnocena jinak v závislosti na tom, do jaké soutěže jí chceme vybrat.
- *SkillDifficulty* - náročnost ve smyslu znalostí a schopností, které jsou potřeba pro její vyřešení. Číslo od 1 do 5 třeba, čím vyšší, tím těžší.
- *WorkDifficulty* - náročnost ve smyslu práce, kterou s ní bude mít někdo, kdo má dostatečné schopnosti na její vyřešení. Opět číslo 1 až 5.
	- příklady hodnocení:
		- 1, 1 - "Za čas t urazíme vzdálenost v, jakou máme průměrnou rychlost?"
		- 1, 5 - "Ověříme podmínku stability na kladce číslo 37."
		- 5, 1 - "Úplně v tom vidíme vlnovou rovnici, po zřejmé substituci dostaneme difku jejíž řešení je už triviální."
		- 5, 5 - "Integrujeme relativistický Planckův zákon přes povrch tělesa ve tvaru pravidelného dvacetistěnu."
- *Interestingess* - zajímavost, nebo také pěknost. Opět 1 až 5, kde 1 je nejvíc nudná a 5 je fakt pěkná.

### Role ###
- Značí speciální roli v soutěži - např. vedoucí, vedoucí korektur, vedoucí výběru ...
- *TypeID* - id typu role (např. vedoucí je 1 ...)

## Vztahy ##
### ProblemCompetition ###
- Úloha je v soutěži. Zřejmě může být v maximálně jedné soutěži.
- Občas by se sice mohlo recyklovat úlohy do soustředkových fyziklání, ale pravděpodobně na nich bude nutné něco upravit, takže bude lepší vytvořit kopii a tu upravovat.

### CurrentDraft ###
- Aktuální draft pro úlohu. Úloha musí vždy být právě v jednom. Pokud je zařazena do soutěže, zůstane v draftsetu pro danou soutěž.

### HistoryDraftset ###
- **Draftset**, kam je úloha navržena.

### DraftEvaluation ###
- Pro daný návrh úlohy do soutěže vzniklo ohodnocení. Úloha může být ohodnocena nejvýše jednou do dané soutěže, hodnocení probíhá při výběru úloh.
- Úloha může být hodnocena jinak v závislosti na tom, do jaké soutěže jí chceme vybrat.

### DirectoryInGroup ###
- Složka je v dané (právě jedné) skupině. Mají k ní přístup jen loginy z dané skupiny. Všechny úlohy v této složce jsou v dané skupině.

### CompetitionDirectory ###
- Soutěž má danou složku.

### DraftDirectory ###
- To samé, ale pro **Draftset**.

### CompetitionDraftset ###
Daný **Draftset** je souborem návrhů na úlohy do dané soutěže. Soutěž může mít jen jeden, ale nějaké draftsety nemusí být pro soutěž (např. trash)

### LoginRole ###
- Login může mít v soutěži více různých rolí.

### CompetitionRole ###
- V soutěži může být více loginů s nějakými rolemi.

# Obrázky a grafy
## Třídy ##
### AdditionalFile ###
- Obrázek k nějaké úloze, data k obrázku nebo tak.
- *Type* - typ, například plt, mp, csv a tak (obrázky co nemají zdroják tu spíš nebudou).
- *ReferenceName* - identifikátor v rámci úlohy (např. "graf" nebo "reseni") - bude to fungovat tak, že obrázek vytvoříme, přidáme k úloze a následně najdeme právě pod tímto identifikátorem. Nicméně z toho důvodu bude nutné před texáním projít všechna makra + tyto soubory a nahradit odkazy na ně příslušným unikátním názvem (např. id úlohy + speciální znak + *ReferenceName*)

### AdditionalFileHistory ###
- Konkrétní verze souboru - tabulka obsahuje historii všech verzí.
- *Content* - obsah.

## Vztahy ##
### ProblemAdditionalFile ###
- Soubor patří k úloze. Každý musí patřit do právě jedné (neznamená to, že musí být přímo v úloze - k tomu je stále potřeba přidat jej např. pomocí \fullfig).
- Sice by se občas mohlo hodit dát jeden obrázek do více úloh, ale to je jednak velmi nepravděpodobné, a za druhé bude stejně většinou potřeba obrázky alespoň trochu upravit. Přiřazení jednoho obrázku do více úloh by tak vedlo k tlaku na to nic neupravovat a dát do obou verzí zcela stejný.

### CurrentAdditionalFile ###
- Aktuální verze souboru.

### AdditionalFileHistory ###
- Daná verze odpovídá danému souboru. Tu nejde použít podobný trik jako v případě celé úlohy, protože z **Action** se nelze dostat na příslušný **AdditionalFile** (protože commity souvisí jen s úlohami, ne s addfily).

# Makra a workfow
## Třídy ##
### DataHistory ###
- Konkrétní verze úlohy. Obsahuje ale pouze netextová makra (jakože ta, která nezávisí na jazyku)
- *Points* - body za úlohu.
- *ComputerResult* - strojově čitelný výsledek primárně pro FOL.
- *OtherTexData* - veškerá další makra, např. obrázky nebo tak - obsah bude vložen přímo do texových dokumentů před překladem.

### LanguageData ###
- Soubor maker pro úlohu, která jsou textová a tedy musí být v jednom konkrétním jazyku.
- *Language* - jazyk (nicméně bude tu nejspíš něco jako mix češtiny a slovenštiny).

### LanguageDataHistory ###
- Konkrétní verze textových maker.
- *Name* - název.
- *Origin* - původ.
- *Task* - zadání.
- *Solution* - řešení.
- *HumanResult* - lidsky čitelný výsledek primárně pro FOF.

### Topic ###
- Seznam všech topics, které pro úlohy používáme (celkem 24). Specifikace (popis, jméno, ...) bude v aplikaci, tu bude fakt jen ID.
- *Name* - název v nějakém univerzálním jazyku (angličtina).

### Flag ###
- Seznam všech flagů pro úlohy. Flagy mohou být například "Není jasné řešení", "Ještě je to potřeba ověřit", "Cancer" a podobně.
- *Name* - název v nějakém univerzálním jazyku (angličtina).

### Work ###
- Představuje jednu "práci" (napsání zadání nebo vzoráku, korekturování ...), kterou s úlohou někdo udělal.
- Work nezávisí na soutěži, protože když má úloha korekturu, tak je jedno, do jaké soutěže - prostě jí má.
- Worky by se neměly vytvářet "dopředu", ale až ve chvíli, kdy je někdo začne dělat. To, které worky mají být kdy hotové a tak bude zapsané přímo v aplikaci (ideálně v konfiguráku).
- *Type* - typ této práce.

### WorkHistory ###
- Konkrétní verze daného worku.
- *Status* - v jakém stavu to je (ještě se nezačalo, probíhá to, je tu nějaký problém, vše hotové ...).

## Vztahy ##
### CurrentData ###
- Každá verze úlohy patří k nějaké úloze. Je k ní připojena přes **Action** a **ProblemCommit**. Úloha si zároveň ukazuje na svojí aktuální verzi.

### ProblemLanguageData ###
- Říká, že daná úloha má daná textová makra v daném jazyku.
- Každá úloha má makra v alespoň jednom jazyku, nemůže jich mít víc ve stejném jazyku.

### LanguageDataHistory ###
- Daná languageDataHistory patří danému languageData.

### CurrentLanguageData ###
- Verzování jako výše.

### ProblemTopic ###
- Značí, že daná úloha má daný topic.
- Každá úloha musí mít alespoň jeden topic, defaultně je "Nezařazeno".

### ProblemFlag ###
- Značí, že daná úloha má daný flag.
- Úloha nemá nijak stanoven počet flagů.
- **TODO** - Nedávalo by smysl mít stejně jako u topics flag "NoFlags"? - Popřípadě, nebylo by jednodušší to mít tak, že i u topics bude "Nezařazeno" jednoduše reprezentováno pomocí žádného topic?

### ProblemWork ###
- Daný work se týká dané úlohy. Úloha může mít libovolně worků (jakože měla by mít alespoň autora, ale není to nutná podmínka pro nic dalšího.)

### WorkHistory ###
- Daná workHistory se týká daného worku.

### CurrentWork ###
- Verzování jako výše.

### Worker ###
- Organizátor dělá daný work.
- Každý work může dělat nejvýše jeden organizátor. Víc jich je potřeba jen v extrémně výjimečných případech, a potom se to vyřeším přidáním speciálního worku typu "SecondAuthor" a tak. Toto omezení je velmi důležité, protože jinak by bylo nutné vytvořit speciální tabulku na vztah N:N, která by se ještě musela verzovat a to už by byl teprve chaos.
- Zdá se logické, že work musí dělat alespoň jeden org. Nicméně, často se lidé na worky zapisují dopředu. Přitom se občas z worku odhlásí a nakonec ho udělá někdo jiný. Pokud by na worku musel vždy někdo být, nešlo by jen smazat orga, musel by se smazat celý work. Potom by se někdy vytvořil nový, ale to už by samozřejmě nenavazovala historie.

# Akce a komentáře
## Třídy ##
### Action ###
- Základní jednotka úpravy něčeho. Každá **-History** třída je vlasntně akce. Akce vykonané na jedné úloze ve stejnou chvíli jedním organizátorem se združují do commmitů. 

### Event ###
- Událost určená tím, kdo jí vykonal, a časem, ve kterém k ní došlo. V rámci události může dojít k více akcím.
- *Time* - čas, kdy k ní došlo.

### ProblemCommit ###
- Sdružuje více akcí, vykonaných na jedné úloze v jednu chvíli. Buď má přiřazený event, nebo je dále sdružen do **CompetitionCommit**. Dále ukazuje na úlohu, které se týká.
- *Text* - nepovinný popis úpravy.

### CompetitionCommit ###
- Sdružuje více akcí, vykonaných na jedné soutěži v jednu chvíli. Například permutace pořadí několika úloh. Má přiřazený **Event** a dále soutěž, které se týká.
- *Text* - nepovinný popis úpravy.

### Issue ###
- Problém v konkrétní fázi práce na úloze (např. při korekturování úlohy se zjistilo, že ...).
- *Name* - název problému.
- *Status* - v jaké fázi řešení problému jsme (na konci tam bude solved, čímž se to skryje jako v korekturovací tabulce).

### Comment ###
- Komentář ve vláknu u nějakého problému. Také je to **Event**.
- *Text* - textový obsah komentáře.

## Vztahy ##
### ProblemCommit ###

### CommitForProblem ###

### ProblemCommitEvent ###
- Pokud problem commit ukazuje na event, znamená to, že je přímo tímto eventem. Jinak musí ukazovat na competition commit.

### CompetitionCommit ###
- Pokud problem commit ukazuje na competition event, znamená to, že je součástí eventu, který daný competition commit reprezentuje.

### CommitForCompetition ###

### CompetitionCommitEvent ###
- Competition commit je daným eventem.

### EventLogin ###

### WorkIssue ###
- Problém patří k dané práci. Každý patří k právě jedné, ale práce může mít libovolně problémů.

### CommentIssue ###
- Komentář patří k danému problému. Musí tam být aspoň jeden a to ten první, podle kterého se pozná, kdo vlákno založil.

### CommentEvent ###
- Vytvoření komentáře je také event.

### WorkAction ###

### DataAction ###

### LanguageDataAction ###

### AdditionalFileAction ###

### DraftAction ###


- TODO - komentář do change?

- TODO - co přidat "issue", což bude vlastně komentář ke korektuře / vzoráku / čemukoli?
	- prostě jako diskuze, akorát u toho bude ještě napsané kdo to má vyřešit
	- lepší nápad, implementovat označování v komentářích
- TODO - název souboru s texovou šablonou pro soutěže a pod
	- do konfiguračních souborů