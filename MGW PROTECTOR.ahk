#SingleInstance, force
#NoEnv
#Include czarUDF.ahk
#Include JSON.ahk
#IfWinActive GTA:SA:MP
SendMode Input
; #######################################################[ПРОВЕРКА РАСКЛАДКИ КЛАВИАТУРЫ]##########################################
Lang_In_Window := DllCall("GetKeyboardLayout", "UInt", Active_Window_Thread)
if (!Lang_In_Window = 67699721)
{
	SendMessage, 0x50,, 0x4090409,, A
	sleep 300
	Reload
}
; #######################################################[АВТООБНОВЛЕНИЕ + ЗАГРУЗКА]##############################################
URLUpdateAHK := "https://github.com/Myshyak666/MGW-PROTECTOR/blob/master/MGW%20UPDATER.exe?raw=true" ; Ссылка на обновление скрипта
URLChangelog := "https://github.com/Myshyak666/MGW-PROTECTOR/raw/master/Changelog.ini" ; Ссылка на список изменений
URLLoginIn := "https://github.com/Myshyak666/MGW-PROTECTOR/raw/master/Images/MGW-PROTECTOR_LOGIN.png"
URLRegistration := "https://github.com/Myshyak666/MGW-PROTECTOR/raw/master/Images/MGW-PROTECTOR_REGISTRATION.png"
URLCheckDataButton := "https://github.com/Myshyak666/MGW-PROTECTOR/raw/master/Images/MGW-PROTECTOR_CHECK-DATA_BUTTON.png"
URLLoginInButton := "https://github.com/Myshyak666/MGW-PROTECTOR/raw/master/Images/MGW%20PROTECTOR-LOGIN_LOGIN-IN_BUTTON.png"
URLIco := "https://github.com/Myshyak666/MGW-PROTECTOR/raw/master/Images/MGW-PROTECTOR_ICO.ico"
BuildSc = 1
SplashTextOn, 500,100, MGW PROTECT | Загрузка . . ., Производится загрузка всех необходимых компонентов.`nПожалуйста, наберитесь терпения, это не займёт у Вас много времени.`n`nОжидайте . . .
FileCreateDir, %A_Temp%\MGW PROTECTOR\Images ; Создание директории
FileSetAttrib, +H, %A_Temp%\MGW PROTECTOR ; Скрыть файл
FileSetAttrib, +H, %A_Temp%\MGW PROTECTOR\Images ; Скрыть файл
URLDownloadToFile, %URLLoginInButton%, %A_Temp%\MGW PROTECTOR\Images\MGW PROTECTOR-LOGIN_LOGIN-IN_BUTTON.png ; Загрузить с интернета изображение
FileSetAttrib, +H, %A_Temp%\MGW PROTECTOR\Images\MGW PROTECTOR-LOGIN_LOGIN-IN_BUTTON.png  ; Скрыть файл
URLDownloadToFile, %URLCheckDataButton%, %A_Temp%\MGW PROTECTOR\Images\MGW-PROTECTOR_CHECK-DATA_BUTTON.png ; Загрузить с интернета изображение
FileSetAttrib, +H, %A_Temp%\MGW PROTECTOR\Images\MGW-PROTECTOR_CHECK-DATA_BUTTON.png  ; Скрыть файл
URLDownloadToFile, %URLIco%, %A_Temp%\MGW PROTECTOR\Images\MGW-PROTECTOR_ICO.ico ; Загрузить с интернета изображение
FileSetAttrib, +H, %A_Temp%\MGW PROTECTOR\Images\MGW-PROTECTOR_ICO.ico  ; Скрыть файл
URLDownloadToFile, %URLLoginIn%, %A_Temp%\MGW PROTECTOR\Images\MGW-PROTECTOR_LOGIN.png ; Загрузить с интернета изображение
FileSetAttrib, +H, %A_Temp%\MGW PROTECTOR\Images\MGW-PROTECTOR_LOGIN.png  ; Скрыть файл
URLDownloadToFile, %URLRegistration%, %A_Temp%\MGW PROTECTOR\Images\MGW-PROTECTOR_REGISTRATION.png ; Загрузить с интернета изображение
FileSetAttrib, +H, %A_Temp%\MGW PROTECTOR\Images\MGW-PROTECTOR_REGISTRATION.png  ; Скрыть файл
URLDownloadToFile, %URLChangelog%, %A_Temp%\MGW PROTECTOR\Changelog.ini ; Загрузить с интернета список изменений
FileSetAttrib, +H, %A_Temp%\MGW PROTECTOR\Changelog.ini ; Скрыть файл
IniRead, OldVersionSc, %A_Temp%\MGW PROTECTOR\Changelog.ini, UPDATE, Version
SplashTextOff
; #######################################################[НАСТРОЙКИ ТРЕЯ]#########################################################
Menu, Tray, NoStandard
Menu, Tray, DeleteAll
Menu, Tray, Icon, %A_Temp%\MGW PROTECTOR\Images\MGW-PROTECTOR_ICO.ico
Menu, Tray, Add, Связаться с разработчиком, ContactUs
Menu, Tray, Add
Menu, Tray, Add, Перезагрузить, ReloadScript
Menu, Tray, Add, Закрыть, GuiClose
TrayTip, Скрипт "MGW PROTECTOR" запущен и готов к работе!, *Примечание*.
; #######################################################[DATA BASE]##############################################################
GetResultCurl(str) 
{ 
if (RegExMatch(str, "<JSON_RESULT>(.*)</JSON_RESULT>", out_pars)) 
return out_pars1 
return 
}
; #######################################################[GUI ИНТЕРФЕЙС]##########################################################
LoginIn:
Gui, LoginIn:Destroy
Gui, LoginIn:Add, Picture, x0 y0 w850 h423, %A_Temp%\MGW PROTECTOR\Images\MGW-PROTECTOR_LOGIN.png
Gui, LoginIn:Add, Picture, x455 y340 +BackgroundTrans gRegistration, %A_Temp%\MGW PROTECTOR\Images\MGW-PROTECTOR_REGISTRATION.png
Gui, LoginIn:Add, Picture, x303 y360 w270 h40 +BackgroundTrans gCheckData, %A_Temp%\MGW PROTECTOR\Images\MGW PROTECTOR-LOGIN_LOGIN-IN_BUTTON.png  ; #4SV (ПОСТАВИТЬ НА ЗАГРУЗКУ ФОТОГРАФИЮ)
Gui, LoginIn:Font, S20 Cce5757, Franklin Gothic Medium
Gui, LoginIn:Add, Edit, x304 y185 w270 h40 +Center vvar_nick, 
Gui, LoginIn:Add, Edit, x304 y290 w270 h40 0x20 +Center vvar_password, 
Gui, LoginIn:Add, Text, x725 y361 h40 +BackgroundTrans, %OldVersionSc%
Gui, LoginIn:Show, w850 h423 , MGW PROTECTOR | Login [%OldVersionSc%]
return
CheckData:
Gui, Loginin:Submit, NoHide
result := GetResultCurl(Curl("POST", "http://myshyak.kl.com.ua/edit.php", {"send": {"action": "login", "nick": var_nick, "password": var_password}}, "AHK"))
if (!result)
{
	MsgBox, % "Не удалось подключится к сайту!"
	return
}
result := JSON.Decode(result)
if (result.code == "good")
{
goto, MainMenu
}
else
{
	MsgBox, % "Не удалось авторизоваться`n`n" result.message
	goto, LoginIn
	return
}
Registration:
Gui, Registration:Show, w400 h150, MGW PROTECTOR | Регистрация
return
MainMenu:
Gui, MainMenu:Destroy
Gui, LoginIn:Destroy
Gui, CheckData:Destroy
Gui, MainMenu:Add, Button, x685 y25 w160 h50, Список команд
Gui, MainMenu:Add, Button, x685 y105 w160 h50 gRulesForAdministration, Правила для администрации
Gui, MainMenu:Add, Button, x685 y185 w160 h50 gPunishmentTable, Таблица Наказаний (ТН)
Gui, MainMenu:Add, Button, x685 y265 w160 h50, [В РАЗРАБОТКЕ]
Gui, MainMenu:Add, Button, x685 y337 w160 h50, Информационный раздел
GuiControl, MainMenu:+Disabled, [В РАЗРАБОТКЕ]
GuiControl, MainMenu:+Disabled, Список команд
GuiControl, MainMenu:+Disabled, Информационный раздел
Gui, MainMenu:Add, Tab, x10 y6 w670 h380, Репорты|Блокировки чата|Кик/КПЗ|Блокировка аккаунта/IP адреса|Бинды|Дополнительно
Gui, MainMenu:Tab, Репорты
Gui, MainMenu:Add, GroupBox, x32 y49 w300 h150 +Center, Слежка за игроком
Gui, MainMenu:Add, Button, x37 y69 w290 h30 gre1, Работать по жалобе игрока
Gui, MainMenu:Add, Button, x37 y99 w290 h30 gre2, Нарушение не обнаружено
Gui, MainMenu:Add, Button, x37 y129 w290 h30 gre3, Нарушитель был наказан
Gui, MainMenu:Add, Button, x37 y159 w290 h30 gre4, Пожелать приятной игры
Gui, MainMenu:Add, GroupBox, x352 y49 w300 h150 +Center, Ответы на репорт
Gui, MainMenu:Add, Button, x357 y69 w290 h30 gFrequentlyAskedQuestions, Часто задаваемые вопросы
;Gui, Add, GroupBox, x25 y250 w635 h70 +Center, Часто задавыемые вопросы
Gui, MainMenu:Tab, Блокировки чата
; ############################################[1 СТРОКА]#########################################
Gui, MainMenu:Add, GroupBox, x18 y57 w649 h50 +Center +BackgroundTrans,
Gui, MainMenu:Add, GroupBox, x18 y57 w215 h248 +Center +BackgroundTrans,
Gui, MainMenu:Add, Button, x22 y70 w200 h30, Флуд
Gui, MainMenu:Add, Button, x242 y70 w200 h30, Капс
Gui, MainMenu:Add, Button, x462 y70 w200 h30, Розжиг
; ############################################################################################
; ############################################[2 СТРОКА]#########################################
Gui, MainMenu:Add, GroupBox, x18 y98 w649 h48 +Center +BackgroundTrans,
Gui, MainMenu:Add, Button, x22 y110 w200 h30, Торговля
Gui, MainMenu:Add, Button, x242 y110 w200 h30, Реклама
Gui, MainMenu:Add, Button, x462 y110 w200 h30, Клевета
; ############################################################################################
; ############################################[3 СТРОКА]#########################################
Gui, MainMenu:Add, GroupBox, x18 y138 w649 h48 +Center +BackgroundTrans,
Gui, MainMenu:Add, Button, x22 y150 w200 h30, Оффтоп в общий чат
Gui, MainMenu:Add, Button, x242 y150 w200 h30, Оффтоп в репорт
Gui, MainMenu:Add, Button, x462 y150 w200 h30, Мат в репорт
; ############################################################################################
; ############################################[4 СТРОКА]#########################################
Gui, MainMenu:Add, GroupBox, x18 y178 w649 h48 +Center +BackgroundTrans,
Gui, MainMenu:Add, Button, x22 y190 w200 h30, Троллинг администрации
Gui, MainMenu:Add, Button, x242 y190 w200 h30, Обсуждение действий администрации
Gui, MainMenu:Add, Button, x462 y190 w200 h30, Оскорбление администрации
; ############################################################################################
; ############################################[5 СТРОКА]#########################################
Gui, MainMenu:Add, GroupBox, x18 y218 w649 h48 +Center +BackgroundTrans,
Gui, MainMenu:Add, Button, x22 y230 w200 h30, Клевета на администратора
Gui, MainMenu:Add, Button, x242 y230 w200 h30, Обман администрации
Gui, MainMenu:Add, Button, x462 y230 w200 h30, Неуважение к администрации
; ############################################################################################
; ############################################[6 СТРОКА]#########################################
Gui, MainMenu:Add, GroupBox, x18 y257 w649 h48 +Center +BackgroundTrans,
Gui, MainMenu:Add, GroupBox, x452 y57 w215 h248 +Center +BackgroundTrans,
Gui, MainMenu:Add, Button, x22 y270 w200 h30, Оскорбление проекта
Gui, MainMenu:Add, Button, x242 y270 w200 h30, Упоминание родных
Gui, MainMenu:Add, Button, x462 y270 w200 h30, Неадекватное поведение
Gui, MainMenu:Add, Button, x17 y40 w650 h20, Оскорбление игроков
; ############################################################################################
Gui, MainMenu:Add, GroupBox, x25 y305 w635 h70 +Center, ПАМЯТКА
Gui, MainMenu:Tab, Кик/КПЗ
Gui, MainMenu:Add, GroupBox, x32 y49 w300 h220 +Center, Кики
Gui, MainMenu:Add, Text, x125 y72 w201 h30 +BackgroundTrans, : Drive By (DB)
Gui, MainMenu:Add, Hotkey, x50 y70 w74 h20,
Gui, MainMenu:Add, Text, x125 y100 w201 h30 +BackgroundTrans, : Team Kill (TK)
Gui, MainMenu:Add, Hotkey, x50 y98 w74 h20,
Gui, MainMenu:Add, Text, x125 y128 w201 h30 +BackgroundTrans, : Spawn Kill (SK)
Gui, MainMenu:Add, Hotkey, x50 y126 w74 h20,
Gui, MainMenu:Add, Text, x125 y156 w201 h30 +BackgroundTrans, : Помеха проходу/спавну/каптуру
Gui, MainMenu:Add, Hotkey, x50 y154 w74 h20,
Gui, MainMenu:Add, Text, x125 y185 w201 h30 +BackgroundTrans, : Оскорбление в нике
Gui, MainMenu:Add, Hotkey, x50 y182 w74 h20,
Gui, MainMenu:Add, Text, x125 y212 w201 h30 +BackgroundTrans, : Неправильный каптур(кусок/обрез)
Gui, MainMenu:Add, Hotkey, x50 y210 w74 h20,
Gui, MainMenu:Add, Text, x125 y240 w201 h30 +BackgroundTrans, : Читы
Gui, MainMenu:Add, Hotkey, x50 y238 w74 h20,
Gui, MainMenu:Add, GroupBox, x32 y279 w620 h90 +Center, КПЗ
Gui, MainMenu:Add, Button, x38 y298 w201 h30, Читы
Gui, MainMenu:Add, Button, x242 y298 w201 h30, Багоюз
Gui, MainMenu:Add, Button, x445 y298 w201 h30, Неправильный каптур(кусок/обрез)
Gui, MainMenu:Add, Button, x38 y333 w608 h30, Сохранить
Gui, MainMenu:Add, GroupBox, x352 y49 w300 h220 +Center, ПАМЯТКА
Gui, MainMenu:Tab, Блокировка аккаунта/IP адреса
Gui, MainMenu:Add, GroupBox, x32 y49 w300 h230 +Center, Блокировка аккаунта
Gui, MainMenu:Add, Button, x75 y70 w201 h30, Читы
Gui, MainMenu:Add, Button, x75 y105 w201 h30, Оскорбление в нике
Gui, MainMenu:Add, Button, x75 y140 w201 h30, Обман администрации
Gui, MainMenu:Add, Button, x75 y175 w201 h30, Неадекватное поведение
Gui, MainMenu:Add, Button, x75 y210 w201 h30, Оскорбление администрации
Gui, MainMenu:Add, Button, x75 y245 w201 h30, Оскорбление родных
Gui, MainMenu:Add, GroupBox, x352 y49 w300 h230 +Center, Блокировка IP адреса
Gui, MainMenu:Add, Button, x400 y70 w201 h30, Читы
Gui, MainMenu:Add, Button, x400 y105 w201 h30, Реклама любого ресурса
Gui, MainMenu:Add, Button, x400 y140 w201 h30, Оскорбление проекта
Gui, MainMenu:Add, Button, x400 y175 w201 h30, Неоднократное оскорбление в нике
Gui, MainMenu:Add, Button, x400 y210 w201 h30, Неоднократное оскорбление родных
Gui, MainMenu:Add, Button, x400 y245 w201 h30, Неоднократное оскорбление администраторов
Gui, MainMenu:Add, GroupBox, x32 y279 w620 h90 +Center, ПАМЯТКА
Gui, MainMenu:Tab, Бинды
Gui, MainMenu:Tab, Дополнительно
Gui, MainMenu:Add, GroupBox, x352 y49 w300 h160 +Center, Включение/отключение функций при заходе в игру
Gui, MainMenu:Add, Checkbox, x362 y179 h20, : Приветствие в админ-чате (не рекомендуется)
Gui, MainMenu:Add, Checkbox, x362 y159 h20, : Заступить на дежурство
Gui, MainMenu:Add, Checkbox, x362 y139 h20, : Включение прослушки VIP чата
Gui, MainMenu:Add, Checkbox, x362 y119 h20, : Включение прослушки чата банд
Gui, MainMenu:Add, Checkbox, x362 y99 h20, : Отключение телефона
Gui, MainMenu:Add, Checkbox, x362 y69 w230 h28, : Отключение мониторинга отключившихся/подключившихся игроков
Gui, MainMenu:Add, GroupBox, x32 y49 w290 h160 +Center, Настройка дежурства
Gui, MainMenu:Add, Button, x41 y150 w270 h50 gSelectDutySkin, Выбрать скин для дежурства
Gui, MainMenu:Add, Checkbox, x42 y67 h20, : Делать скриншоты при выдаче кика
Gui, MainMenu:Add, Checkbox, x42 y87 h20, : Делать скриншоты при выдаче бана чата
Gui, MainMenu:Add, Checkbox, x42 y107 h20, : Делать скриншоты при выдаче КПЗ
Gui, MainMenu:Add, Checkbox, x42 y127 h20, : Делать скриншоты при выдаче бана
Gui, MainMenu:Add, GroupBox, x32 y210 w290 h130 +Center, Дополнительные настройки
Gui, MainMenu:Add, GroupBox, x352 y210 w300 h130 +Center,
Gui, MainMenu:Add, Checkbox, x42 y235 h20, : Сохранять chatlog.txt
Gui, MainMenu:Add, Checkbox, x42 y256 w15 h20, ; Установить время
Gui, MainMenu:Add, Checkbox, x42 y281 w15 h20, ; Установить погоду
Gui, MainMenu:Add, Checkbox, x42 y306 h20, : Таймер слежки за игроком
Gui, MainMenu:Add, DropDownList, x62 y255 w55 h200 , 0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23
Gui, MainMenu:Add, DropDownList, x62 y280 w55 h200 , 0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|32|33|34|35|36|37|38|39|40|41|42|43|44|45
Gui, MainMenu:Add, Text, x120 y258 h20 +BackgroundTrans, : Установить время
Gui, MainMenu:Add, Text, x120 y283 h20 +BackgroundTrans, : Установить погоду
Gui, MainMenu:Add, Button, x465 y350 w200 h20 gLog, Лог действий
Gui, MainMenu:Show, w850 h423 , MGW PROTECTOR | Главное меню [%OldVersionSc%]
return
FrequentlyAskedQuestions:
Gui, FrequentlyAskedQuestions:Show, w370 h423, Часто задаваемые вопросы
return
PunishmentTable:
Gui, PunishmentTable:Destroy
Gui, RulesForAdministration:Destroy
Gui, RulesForAdministrationCommon:Destroy
Gui, RulesForAdministrationRecovery:Destroy
Gui, RulesForAdministrationWarn:Destroy
Gui, RulesForAdministrationDismissal:Destroy
Gui, ChatBanTable:Destroy
Gui, KickTable:Destroy
Gui, JailTable:Destroy
Gui, BanTable:Destroy
Gui, BanIPTable:Destroy
Gui, BanForumTable:Destroy
Gui, PunishmentTable:Add, Button, x40 y25 w290 h30 +Center gChatBanTable, Выдача блокировки чата (БЧ)
Gui, PunishmentTable:Add, Button, x40 y60 w290 h30 +Center gKickTable, Выдача кика
Gui, PunishmentTable:Add, Button, x40 y95 w290 h30 +Center gJailTable, Выдача КПЗ
Gui, PunishmentTable:Add, Button, x40 y130 w290 h30 +Center gBanTable, Выдача блокировки аккаунта
Gui, PunishmentTable:Add, Button, x40 y165 w290 h30 +Center gBanIPTable, Выдача блокировки IP адреса
Gui, PunishmentTable:Add, Button, x40 y200 w290 h30 +Center gBanForumTable, Выдача блокировки форумного аккаунта (ФА)
GuiControl, PunishmentTable:+Disabled, Выдача блокировки форумного аккаунта (ФА)
Gui, PunishmentTable:Add, Button, x40 y235 w290 h30 +Center gPunishmentTableClose, Закрыть
Gui, PunishmentTable:Font, cRed
Gui, PunishmentTable:Add, Text, x100 y272 h20 +BackgroundTrans, Актуально на момент [18/08/2018]
Gui, PunishmentTable:Font, cBlack
Gui, PunishmentTable:Show, w364 h294, Таблица наказаний (ТН)
return
ChatBanTable:
Gui, PunishmentTable:Destroy
Gui, RulesForAdministration:Destroy
Gui, ChatBanTable:Add, Button, x40 y478 w420 h20 +Center gPunishmentTableURL, перейти на страницу
Gui, ChatBanTable:Add, Button, x40 y498 w210 h30 +Center gPunishmentTable, Назад
Gui, ChatBanTable:Add, Button, x250 y498 w210 h30 +Center gChatBanTableClose, Закрыть
Gui, ChatBanTable:Add, GroupBox, x40 y10 w420 h464 +BackgroundTrans, ; Обводка
Gui, ChatBanTable:Add, GroupBox, x50 y25 w398 h30 +BackgroundTrans, ; Таблица горизонтальная №0
Gui, ChatBanTable:Add, GroupBox, x50 y47 w398 h30 +BackgroundTrans, ; Таблица горизонтальная №1
Gui, ChatBanTable:Add, GroupBox, x50 y69 w398 h30 +BackgroundTrans, ; Таблица горизонтальная №2
Gui, ChatBanTable:Add, GroupBox, x50 y91 w398 h30 +BackgroundTrans, ; Таблица горизонтальная №3
Gui, ChatBanTable:Add, GroupBox, x50 y113 w398 h30 +BackgroundTrans, ; Таблица горизонтальная №4
Gui, ChatBanTable:Add, GroupBox, x50 y134 w398 h30 +BackgroundTrans, ; Таблица горизонтальная №5
Gui, ChatBanTable:Add, GroupBox, x50 y155 w398 h30 +BackgroundTrans, ; Таблица горизонтальная №6
Gui, ChatBanTable:Add, GroupBox, x50 y176 w398 h30 +BackgroundTrans, ; Таблица горизонтальная №7
Gui, ChatBanTable:Add, GroupBox, x50 y197 w398 h30 +BackgroundTrans, ; Таблица горизонтальная №8
Gui, ChatBanTable:Add, GroupBox, x50 y218 w398 h30 +BackgroundTrans, ; Таблица горизонтальная №9
Gui, ChatBanTable:Add, GroupBox, x50 y239 w398 h30 +BackgroundTrans, ; Таблица горизонтальная №10
Gui, ChatBanTable:Add, GroupBox, x50 y260 w398 h30 +BackgroundTrans, ; Таблица горизонтальная №11
Gui, ChatBanTable:Add, GroupBox, x50 y281 w398 h30 +BackgroundTrans, ; Таблица горизонтальная №12
Gui, ChatBanTable:Add, GroupBox, x50 y302 w398 h30 +BackgroundTrans, ; Таблица горизонтальная №13
Gui, ChatBanTable:Add, GroupBox, x50 y323 w398 h30 +BackgroundTrans, ; Таблица горизонтальная №14
Gui, ChatBanTable:Add, GroupBox, x50 y344 w398 h30 +BackgroundTrans, ; Таблица горизонтальная №15
Gui, ChatBanTable:Add, GroupBox, x50 y365 w398 h30 +BackgroundTrans, ; Таблица горизонтальная №16
Gui, ChatBanTable:Add, GroupBox, x50 y386 w398 h30 +BackgroundTrans, ; Таблица горизонтальная №17
Gui, ChatBanTable:Add, GroupBox, x50 y407 w398 h30 +BackgroundTrans, ; Таблица горизонтальная №18
Gui, ChatBanTable:Add, GroupBox, x50 y428 w398 h30 +BackgroundTrans, ; Таблица горизонтальная №19
Gui, ChatBanTable:Add, GroupBox, x250 y25 w100 h433 +BackgroundTrans, ; Таблица вертикальная №0
Gui, ChatBanTable:Font,, Franklin Gothic Medium
Gui, ChatBanTable:Font, bold
Gui, ChatBanTable:Font, cPurple
Gui, ChatBanTable:Add, Text, x55 y35 +BackgroundTrans, Причина
Gui, ChatBanTable:Add, Text, x265 y35 +BackgroundTrans, Наказание
Gui, ChatBanTable:Add, Text, x360 y35 +BackgroundTrans, Примечание
Gui, ChatBanTable:Font, cBlack
Gui, ChatBanTable:Font, Normal
Gui, ChatBanTable:Add, Text, x55 y57 +BackgroundTrans, Флуд
Gui, ChatBanTable:Add, Text, x55 y79 +BackgroundTrans, Капс
Gui, ChatBanTable:Add, Text, x55 y101 +BackgroundTrans, Розжиг
Gui, ChatBanTable:Add, Text, x55 y123 +BackgroundTrans, Реклама любого ресурса
Gui, ChatBanTable:Add, Text, x55 y145 +BackgroundTrans, Торговля
Gui, ChatBanTable:Add, Text, x55 y167 +BackgroundTrans, Оффтоп в репорт
Gui, ChatBanTable:Add, Text, x55 y187 +BackgroundTrans, Мат в репорт
Gui, ChatBanTable:Add, Text, x55 y208 +BackgroundTrans, Обман администрации
Gui, ChatBanTable:Add, Text, x55 y229 +BackgroundTrans, Клевета
Gui, ChatBanTable:Add, Text, x55 y249 +BackgroundTrans, Оскорбление проекта
Gui, ChatBanTable:Add, Text, x55 y270 +BackgroundTrans, Оскорбление игроков
Gui, ChatBanTable:Add, Text, x55 y290 +BackgroundTrans, Троллинг администрации
Gui, ChatBanTable:Add, Text, x55 y312 +BackgroundTrans, Неуважение к администрации
Gui, ChatBanTable:Add, Text, x55 y334 +BackgroundTrans, Оскорбление администрации
Gui, ChatBanTable:Add, Text, x55 y355 +BackgroundTrans, Обсуждение действий администрации
Gui, ChatBanTable:Add, Text, x55 y375 +BackgroundTrans, Клевета на администратора
Gui, ChatBanTable:Add, Text, x55 y396 +BackgroundTrans, Упоминание родных
Gui, ChatBanTable:Add, Text, x55 y417 +BackgroundTrans, Неадекватное поведение
Gui, ChatBanTable:Add, Text, x55 y438 +BackgroundTrans, Оффтоп в /o
Gui, ChatBanTable:Font, cRed, Franklin Gothic Medium
Gui, ChatBanTable:Add, Text, x280 y57 +BackgroundTrans, 5-20min.
Gui, ChatBanTable:Add, Text, x280 y79 +BackgroundTrans, 5-20min.
Gui, ChatBanTable:Add, Text, x280 y101 +BackgroundTrans, 60-180min.
Gui, ChatBanTable:Add, Text, x280 y123 +BackgroundTrans, 60-180min.
Gui, ChatBanTable:Add, Text, x280 y145 +BackgroundTrans, 40-60min.
Gui, ChatBanTable:Add, Text, x280 y167 +BackgroundTrans, 10-20min.
Gui, ChatBanTable:Add, Text, x280 y187 +BackgroundTrans, 10-20min.
Gui, ChatBanTable:Add, Text, x280 y208 +BackgroundTrans, 30-60min.
Gui, ChatBanTable:Add, Text, x280 y229 +BackgroundTrans, 40-60min.
Gui, ChatBanTable:Add, Text, x280 y249 +BackgroundTrans, 180min.
Gui, ChatBanTable:Add, Text, x280 y270 +BackgroundTrans, 10-30min.
Gui, ChatBanTable:Add, Text, x280 y290 +BackgroundTrans, 60-120min.
Gui, ChatBanTable:Add, Text, x280 y312 +BackgroundTrans, 60-120min.
Gui, ChatBanTable:Add, Text, x280 y334 +BackgroundTrans, 180min.
Gui, ChatBanTable:Add, Text, x280 y355 +BackgroundTrans, 120-180min.
Gui, ChatBanTable:Add, Text, x280 y375 +BackgroundTrans, 60-120min.
Gui, ChatBanTable:Add, Text, x280 y396 +BackgroundTrans, 180min.
Gui, ChatBanTable:Add, Text, x280 y417 +BackgroundTrans, 30-40min.
Gui, ChatBanTable:Add, Text, x280 y438 +BackgroundTrans, 40-60min.
Gui, ChatBanTable:Add, Text, x350 y417 +BackgroundTrans, Капс, Флуд, Оск
Gui, ChatBanTable:Font, S6
Gui, ChatBanTable:Add, Text, x350 y434 w30 +BackgroundTrans, Передача/обмен/покупка/`nпродажа аккаунтов
Gui, ChatBanTable:Font, Normal
Gui, ChatBanTable:Show, w500 h530, Выдача блокировки чата (БЧ)
return
KickTable:
Gui, PunishmentTable:Destroy
Gui, RulesForAdministration:Destroy
Gui, KickTable:Add, Button, x40 y225 w380 h20 +Center gPunishmentTableURL, перейти на страницу
Gui, KickTable:Add, Button, x40 y245 w190 h30 +Center gPunishmentTable, Назад
Gui, KickTable:Add, Button, x230 y245 w190 h30 +Center gChatBanTableClose, Закрыть
Gui, KickTable:Add, GroupBox, x40 y10 w380 h212 +BackgroundTrans, ; Обводка
Gui, KickTable:Add, GroupBox, x225 y25 w100 h181 +BackgroundTrans, ; Таблица вертикальная №0
Gui, KickTable:Add, GroupBox, x50 y25 w360 h30 +BackgroundTrans, ; Таблица горизонтальная №0
Gui, KickTable:Add, GroupBox, x50 y47 w360 h30 +BackgroundTrans, ; Таблица горизонтальная №1
Gui, KickTable:Add, GroupBox, x50 y69 w360 h30 +BackgroundTrans, ; Таблица горизонтальная №2
Gui, KickTable:Add, GroupBox, x50 y91 w360 h30 +BackgroundTrans, ; Таблица горизонтальная №3
Gui, KickTable:Add, GroupBox, x50 y113 w360 h30 +BackgroundTrans, ; Таблица горизонтальная №4
Gui, KickTable:Add, GroupBox, x50 y134 w360 h30 +BackgroundTrans, ; Таблица горизонтальная №5
Gui, KickTable:Add, GroupBox, x50 y155 w360 h30 +BackgroundTrans, ; Таблица горизонтальная №6
Gui, KickTable:Add, GroupBox, x50 y176 w360 h30 +BackgroundTrans, ; Таблица горизонтальная №7
Gui, KickTable:Font,, Franklin Gothic Medium
Gui, KickTable:Font, bold
Gui, KickTable:Font, cPurple
Gui, KickTable:Add, Text, x55 y35 +BackgroundTrans, Причина
Gui, KickTable:Add, Text, x245 y35 +BackgroundTrans, Наказание
Gui, KickTable:Add, Text, x329 y35 +BackgroundTrans, Примечание
Gui, KickTable:Font, cBlack
Gui, KickTable:Font, Normal
Gui, KickTable:Add, Text, x55 y57 +BackgroundTrans, DriveBy
Gui, KickTable:Add, Text, x55 y79 +BackgroundTrans, TeamKill
Gui, KickTable:Add, Text, x55 y101 +BackgroundTrans, SpawnKill
Gui, KickTable:Add, Text, x55 y123 +BackgroundTrans, Помеха проходу/спавну/каптуру
Gui, KickTable:Add, Text, x55 y143 +BackgroundTrans, Оскорбление в нике
Gui, KickTable:Add, Text, x55 y165 +BackgroundTrans, Неправильный каптур
Gui, KickTable:Add, Text, x55 y187 +BackgroundTrans, Чит
Gui, KickTable:Font, cRed
Gui, KickTable:Add, Text, x266 y57 +BackgroundTrans, Kick
Gui, KickTable:Add, Text, x266 y79 +BackgroundTrans, Kick
Gui, KickTable:Add, Text, x266 y101 +BackgroundTrans, Kick
Gui, KickTable:Add, Text, x266 y123 +BackgroundTrans, Kick
Gui, KickTable:Add, Text, x266 y145 +BackgroundTrans, Kick
Gui, KickTable:Add, Text, x266 y167 +BackgroundTrans, Kick
Gui, KickTable:Add, Text, x266 y187 +BackgroundTrans, Kick
Gui, KickTable:Add, Text, x331 y163 +BackgroundTrans, (кусок/обрез)
Gui, KickTable:Font, S6
Gui, KickTable:Add, Text, x325 y119 +BackgroundTrans, Если игрок находиться`nбольше 1 минуты в AFK
Gui, KickTable:Font, Normal
Gui, KickTable:Add, Text, x326 y182 +BackgroundTrans, Если нету старшей`nадминистрации
;Gui, KickTable:Add, GroupBox, x10 y10 w50 h100 +BackgroundTrans,
Gui, KickTable:Show, w460 h295, Выдача кика
return
JailTable:
Gui, PunishmentTable:Destroy
Gui, RulesForAdministration:Destroy
Gui, JailTable:Add, Button, x40 y350 w380 h20 +Center gPunishmentTableURL, перейти на страницу
Gui, JailTable:Add, Button, x40 y370 w190 h30 +Center gPunishmentTable, Назад
Gui, JailTable:Add, Button, x230 y370 w190 h30 +Center gChatBanTableClose, Закрыть
Gui, JailTable:Add, GroupBox, x40 y10 w380 h340 +BackgroundTrans,
Gui, JailTable:Show, w460 h423, Выдача КПЗ
return
BanTable:
Gui, PunishmentTable:Destroy
Gui, RulesForAdministration:Destroy
Gui, BanTable:Add, Button, x40 y350 w380 h20 +Center gPunishmentTableURL, перейти на страницу
Gui, BanTable:Add, Button, x40 y370 w190 h30 +Center gPunishmentTable, Назад
Gui, BanTable:Add, Button, x230 y370 w190 h30 +Center gChatBanTableClose, Закрыть
Gui, BanTable:Add, GroupBox, x40 y10 w380 h340 +BackgroundTrans,
Gui, BanTable:Show, w460 h423, Выдача блокировки аккаунта
return
BanIPTable:
Gui, PunishmentTable:Destroy
Gui, RulesForAdministration:Destroy
Gui, BanIPTable:Add, Button, x40 y350 w380 h20 +Center gPunishmentTableURL, перейти на страницу
Gui, BanIPTable:Add, Button, x40 y370 w190 h30 +Center gPunishmentTable, Назад
Gui, BanIPTable:Add, Button, x230 y370 w190 h30 +Center gChatBanTableClose, Закрыть
Gui, BanIPTable:Add, GroupBox, x40 y10 w380 h340 +BackgroundTrans,
Gui, BanIPTable:Show, w460 h423, Выдача блокировки IP адреса
return
BanForumTable:
Gui, PunishmentTable:Destroy
Gui, RulesForAdministration:Destroy
Gui, BanForumTable:Add, Button, x40 y350 w380 h20 +Center gPunishmentTableURL, перейти на страницу
Gui, BanForumTable:Add, Button, x40 y370 w190 h30 +Center gPunishmentTable, Назад
Gui, BanForumTable:Add, Button, x230 y370 w190 h30 +Center gChatBanTableClose, Закрыть
Gui, BanForumTable:Add, GroupBox, x40 y10 w380 h340 +BackgroundTrans,
Gui, BanForumTable:Show, w460 h423, Выдача блокировки форумного аккаунта (ФА)
return
RulesForAdministration:
Gui, RulesForAdministration:Destroy
Gui, RulesForAdministrationCommon:Destroy
Gui, RulesForAdministrationRecovery:Destroy
Gui, RulesForAdministrationWarn:Destroy
Gui, RulesForAdministrationDismissal:Destroy
Gui, PunishmentTable:Destroy
Gui, RulesForAdministration:Add, Button, x40 y25 w290 h30 +Center gRulesForAdministrationCommon, Общее
Gui, RulesForAdministration:Add, Button, x40 y60 w290 h30 +Center gRulesForAdministrationRecovery, Восстановление на пост администратора
Gui, RulesForAdministration:Add, Button, x40 y95 w290 h30 +Center gRulesForAdministrationWarn, За что можно получить предупреждение
Gui, RulesForAdministration:Add, Button, x40 y130 w290 h30 +Center gRulesForAdministrationDismissal, За что можно лишиться должности`n(В некоторых случаях последует Черный Список[ЧС] )
Gui, RulesForAdministration:Add, Button, x40 y165 w290 h30 +Center gRulesForAdministrationClose, Закрыть
Gui, RulesForAdministration:Font, cRed
Gui, RulesForAdministration:Add, Text, x100 y200 h20 +BackgroundTrans, Актуально на момент [18/08/2018]
Gui, RulesForAdministration:Font, cBlack
Gui, RulesForAdministration:Show, w370 h225, Правила для администрации
return
RulesForAdministrationCommon:
Gui, RulesForAdministration:Destroy
Gui, RulesForAdministrationCommon:Add, Button, x35 y350 w300 h20 +Center gRulesForAdministrationURL, перейти на страницу
Gui, RulesForAdministrationCommon:Add, Button, x185 y370 w150 h30 +Center gRulesForAdministrationCommonClose, Закрыть
Gui, RulesForAdministrationCommon:Add, Button, x35 y370 w150 h30 +Center gRulesForAdministration, Назад
Gui, RulesForAdministrationCommon:Add, GroupBox, x36 y20 w298 h325 +BackgroundTrans, ; Обводка №1
Gui, RulesForAdministrationCommon:Add, GroupBox, x60 y40 w250 h30 +BackgroundTrans, ; Таблица горизонтальная №1
Gui, RulesForAdministrationCommon:Add, GroupBox, x60 y62 w250 h30 +BackgroundTrans, ; Таблица горизонтальная №2
Gui, RulesForAdministrationCommon:Add, GroupBox, x60 y84 w250 h30 +BackgroundTrans, ; Таблица горизонтальная №3
Gui, RulesForAdministrationCommon:Add, GroupBox, x60 y40 w60 h74 +BackgroundTrans, ; Таблица вертикальная №1
Gui, RulesForAdministrationCommon:Add, GroupBox, x118 y40 w50 h74 +BackgroundTrans, ; Таблица вертикальная №2
Gui, RulesForAdministrationCommon:Add, GroupBox, x212 y40 w50 h74 +BackgroundTrans, ; Таблица вертикальная №4
Gui, RulesForAdministrationCommon:Font,, Franklin Gothic Medium
Gui, RulesForAdministrationCommon:Add, Text, x75 y50 h20 +BackgroundTrans, Сервер:
Gui, RulesForAdministrationCommon:Font, cFFA500
Gui, RulesForAdministrationCommon:Add, Text, x135 y50 h20 +BackgroundTrans, One
Gui, RulesForAdministrationCommon:Font, cRed
Gui, RulesForAdministrationCommon:Add, Text, x178 y50 h20 +BackgroundTrans, Two
Gui, RulesForAdministrationCommon:Font, cGreen
Gui, RulesForAdministrationCommon:Add, Text, x223 y50 h20 +BackgroundTrans, Three
Gui, RulesForAdministrationCommon:Font, cBlue
Gui, RulesForAdministrationCommon:Add, Text, x273 y50 h20 +BackgroundTrans, Four
Gui, RulesForAdministrationCommon:Font, cBlack
Gui, RulesForAdministrationCommon:Add, Text, x79 y73 h20 +BackgroundTrans, Норма:
Gui, RulesForAdministrationCommon:Add, Text, x137 y72 h20 +BackgroundTrans, 6h
Gui, RulesForAdministrationCommon:Add, Text, x180 y72 h20 +BackgroundTrans, 12h
Gui, RulesForAdministrationCommon:Add, Text, x230 y72 h20 +BackgroundTrans, 6h
Gui, RulesForAdministrationCommon:Add, Text, x277 y72 h20 +BackgroundTrans, 6h
Gui, RulesForAdministrationCommon:Add, Text, x63 y95 h20 +BackgroundTrans, Проверка:
Gui, RulesForAdministrationCommon:Add, Text, x123 y95 h20 +BackgroundTrans, СР и СБ
Gui, RulesForAdministrationCommon:Add, Text, x183 y95 h20 +BackgroundTrans, ВС
Gui, RulesForAdministrationCommon:Add, Text, x217 y95 h20 +BackgroundTrans, СР и СБ
Gui, RulesForAdministrationCommon:Add, Text, x265 y95 h20 +BackgroundTrans, СР и СБ
Gui, RulesForAdministrationCommon:Add, GroupBox, x60 y110 w250 h220 +BackgroundTrans, ; Обводка №2
Gui, RulesForAdministrationCommon:Add, Edit, x64 y120 w241 h205 +BackgroundTrans, 1 | Каждое воскресенье выбирается лучший администратор(ЛА) недели. ЛА можно стать, набрав наибольшее количество онлайна среди администрации. Награда: 20 доната и снятие одного предупреждения, если имеются.`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n2 | Онлайн учитывается только на дежурстве (/duty)`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n3 | Использовать читы разрешено, исключительно на дежурстве (/duty)`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n4 | Если вы столкнулись с проблемой "Несовпадение провайдера", следует написать Главному/Заместителю главного администратора.`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n5 | Выдавать наказание строго по таблице наказаний.`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n6 | Брать отпуск можно 1 раз в месяц. Примечания: Отпуск можно брать только администраторам старше 2 уровня и максимум на 14 дней. Играть во время отпуска запрещено.`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n7 | Запрещено стоять/бегать/летать рядом с игроками в /dm режиме. (Используйте: /flycam или же зайдите в текстуру с помощью чит-программ)`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n8 | Запрещено играть на админке. Исключение: Разрешение 6+ уровней, НО при условии, что Вы не будете игнорировать репорт`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n9 | Вы обязательно должны иметь видеофиксацию(фрапс) нарушения игроков, в противном случае, вы будете наказаны. (Обязателен момент нарушения | Фрапс на aim и подобные нарушения строго от 1+ минуты)`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n10 | Доказательства на нарушения строго заливать на видеохостинг Youtube в доступе по ссылке, иначе будет считаться за слив админ. информации.`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n11 | Доказательства на жалобы предоставлять строго Следящему за жалобами/ЗГА/ГА и выше.`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n12 | Запрещено отписываться в теме на другого администратора.`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n13 | При потере админ пароля писать Главному администратору или его заместителю. При потере пароля от аккаунта/кода безопасности писать в технический раздел.`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n14 | При повышении уровня отписываться в специальной теме. Она находится в админ разделе вашего сервера.`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n15 |  По всем вопросам писать Главному администратору/Заместителю главного администратора.
Gui, RulesForAdministrationCommon:Show, w370 h426, Общее
return
RulesForAdministrationRecovery:
Gui, RulesForAdministration:Destroy
Gui, RulesForAdministrationRecovery:Add, Button, x35 y350 w300 h20 +Center gRulesForAdministrationURL, перейти на страницу
Gui, RulesForAdministrationRecovery:Add, Button, x185 y370 w150 h30 +Center gRulesForAdministrationRecoveryClose, Закрыть
Gui, RulesForAdministrationRecovery:Add, Button, x35 y370 w150 h30 +Center gRulesForAdministration, Назад
Gui, RulesForAdministrationRecovery:Add, GroupBox, x36 y20 w298 h325 +BackgroundTrans, ; Обводка №1
Gui, RulesForAdministrationRecovery:Font,, Franklin Gothic Medium
Gui, RulesForAdministrationRecovery:Add, Edit, x40 y30 w289 h310 +BackgroundTrans, 1 | Если вы были администратором 1 уровня при наличии максимум 1-го предупреждения, то вы имеете право восстановится только 1 раз с 1 предупреждением.`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n2 | Если вы были администратором 2+ уровня, вы можете восстанавливаться хоть сколько раз, но при каждом восстановлении вы теряете один уровень, + получаете столько предупреждений, сколько у вас было на момент ухода ПСЖ.`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n3 | Восстановление возможно, если Вы уходили максимум с 2 предупреждениями. На 1 уровне максимум с одним, в остальных случая вам будет отказано в восстановолении.
Gui, RulesForAdministrationRecovery:Show, w370 h426, Восстановление на пост администратора
return
RulesForAdministrationWarn:
Gui, RulesForAdministration:Destroy
Gui, RulesForAdministrationWarn:Add, Button, x35 y350 w300 h20 +Center gRulesForAdministrationURL, перейти на страницу
Gui, RulesForAdministrationWarn:Add, Button, x185 y370 w150 h30 +Center gRulesForAdministrationWarnClose, Закрыть
Gui, RulesForAdministrationWarn:Add, Button, x35 y370 w150 h30 +Center gRulesForAdministration, Назад
Gui, RulesForAdministrationWarn:Add, GroupBox, x36 y20 w298 h325 +BackgroundTrans, ; Обводка №1
Gui, RulesForAdministrationWarn:Font,, Franklin Gothic Medium
Gui, RulesForAdministrationWarn:Add, Edit, x40 y30 w289 h310 +BackgroundTrans, 1 | Выдача наказаний не по таблице.`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n2 | Игнорирование репорта`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n3 | Оскорбление игроков/администрации`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n4 | Неуважение к администрации/игрокам`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n5 | Нанесение ущерба игрокам. В том числе убийство/нанесение урона игрокам на дежурстве (/duty)`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n6 | Читы в личных целях`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n7 | Накрутка статистики/Кач. часов`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n8 | Превышение полномочий/Блат`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n9 | Не предоставил доказательства на жалобу в течение 24-х часов`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n10 | Не отписался в теме "Отписка о повышении уровня" в течение 3-х дней с момента повышения`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n11 | Выход из конференции скайпа`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n12 | Неадекватное поведение в игре/скайпе (Мат в любой форме/Offtop/Flood)`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n13 | Выпрашивание повышения/снятия предупреждения и подобное`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n14 | Отписка в жалобе на другого администратора`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n15 | Игра на админке без разрешения`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n16 | Неотыгровка нормы`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n17 | Использование читов без /duty`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n18 | Админ информация в открытом доступе`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n19 | Перекраска территорий без доказательств`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n20 | Находится в игре во время отпуска`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n21 | Провокация администрации`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n22 | Распространение вредоносных программ среди администрации`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n23 | Снятие чужого наказания. (Исключение: Администратор сам попросил вас снять наказание.)`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n24 | Выдача /kick /jail за читы когда старшая администрация online`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n25 | Двойное наказание. 
Gui, RulesForAdministrationWarn:Show, w370 h426, За что можно получить предупреждение
return
RulesForAdministrationDismissal:
Gui, RulesForAdministration:Destroy
Gui, RulesForAdministrationDismissal:Add, Button, x35 y350 w300 h20 +Center gRulesForAdministrationURL, перейти на страницу
Gui, RulesForAdministrationDismissal:Add, Button, x185 y370 w150 h30 +Center gRulesForAdministrationDismissalClose, Закрыть
Gui, RulesForAdministrationDismissal:Add, Button, x35 y370 w150 h30 +Center gRulesForAdministration, Назад
Gui, RulesForAdministrationDismissal:Add, GroupBox, x36 y20 w298 h325 +BackgroundTrans, ; Обводка №1
Gui, RulesForAdministrationDismissal:Font,, Franklin Gothic Medium
Gui, RulesForAdministrationDismissal:Add, Edit, x40 y30 w289 h310 +BackgroundTrans, 1 | Оскорбление администрации/проекта/игроков/родных`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n2 | Получение 3-го предупреждения`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n3 | Реклама любого ресурса`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n4 | Нанесение ущерба игрокам`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n5 | Превышение полномочий/Блат`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n6 | Обман Главной администрации`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n7 | Продажа/Передача аккаунта`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n8 | Разглашение админ информации`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n9 | Розжиг межнациональной розни`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n10 | Нарушение правил на другом сервере/аккаунте проекта Monser.ru`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n11 | Неактив`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n12 | Распространение вредоносных программ с последующим нанесением ущерба`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n13 | Продажа автовыдачи/ahk/скриптов/cleo и т.д.
Gui, RulesForAdministrationDismissal:Show, w370 h426, За что можно лишиться должности
return
SelectDutySkin:
Gui, SelectDutySkin:Show, w479 h576, Выберите скин для дежурства
return
; #######################################################[НАКАЗАНИЯ]###############################################################
re1:
Gui, re1:Destroy
Gui, re2:Destroy
Gui, re3:Destroy
Gui, re4:Destroy
Gui, re1:Add, Text, x21 y20 h20 +BackgroundTrans, {     Hotkey     }
Gui, re1:Add, Text, x100 y20 h20 +BackgroundTrans, {                                                                          Ваш текст                                                                         }
Gui, re1:Add, Checkbox, x610 y40 h20 +BackgroundTrans, {Enter}
GuiControl, re1:+Disabled, {Enter}
Gui, re1:Add, GroupBox, x3 y0 w694 h93 +BackgroundTrans,
Gui, re1:Add, Edit, x100 y40 w500 h20
Gui, re1:Add, DropDownList, x100 y65 w500 h100, 1|2|3|4|5
Gui, re1:Add, Hotkey, x20 y40 w73 h20
Gui, re1:Add, Button, x3 y96 w694 h40, Сохранить
Gui, re1:Show, w700 h140, Работать по жалобе игрока
return
re2:
Gui, re1:Destroy
Gui, re2:Destroy
Gui, re3:Destroy
Gui, re4:Destroy
Gui, re2:Add, Text, x21 y20 h20 +BackgroundTrans, {     Hotkey     }
Gui, re2:Add, Text, x100 y20 h20 +BackgroundTrans, {                                                                          Ваш текст                                                                         }
Gui, re2:Add, Checkbox, x610 y40 h20 +BackgroundTrans, {Enter}
GuiControl, re2:+Disabled, {Enter}
Gui, re2:Add, GroupBox, x3 y0 w694 h93 +BackgroundTrans,
Gui, re2:Add, Edit, x100 y40 w500 h20
Gui, re2:Add, DropDownList, x100 y65 w500 h100, 1|2|3|4|5
Gui, re2:Add, Hotkey, x20 y40 w73 h20
Gui, re2:Add, Button, x3 y96 w694 h40, Сохранить
Gui, re2:Show, w700 h140, Нарушение не обнаружено
return
re3:
Gui, re1:Destroy
Gui, re2:Destroy
Gui, re3:Destroy
Gui, re4:Destroy
Gui, re3:Add, Text, x21 y20 h20 +BackgroundTrans, {     Hotkey     }
Gui, re3:Add, Text, x100 y20 h20 +BackgroundTrans, {                                                                          Ваш текст                                                                         }
Gui, re3:Add, Checkbox, x610 y40 h20 +BackgroundTrans, {Enter}
GuiControl, re3:+Disabled, {Enter}
Gui, re3:Add, GroupBox, x3 y0 w694 h93 +BackgroundTrans,
Gui, re3:Add, Edit, x100 y40 w500 h20
Gui, re3:Add, DropDownList, x100 y65 w500 h100, 1|2|3|4|5
Gui, re3:Add, Hotkey, x20 y40 w73 h20
Gui, re3:Add, Button, x3 y96 w694 h40, Сохранить
Gui, re3:Show, w700 h140, Нарушитель был наказан
return
re4:
Gui, re1:Destroy
Gui, re2:Destroy
Gui, re3:Destroy
Gui, re4:Destroy
Gui, re4:Add, Text, x21 y20 h20 +BackgroundTrans, {     Hotkey     }
Gui, re4:Add, Text, x100 y20 h20 +BackgroundTrans, {                                                                          Ваш текст                                                                         }
Gui, re4:Add, Checkbox, x610 y40 h20 +BackgroundTrans, {Enter}
GuiControl, re4:+Disabled, {Enter}
Gui, re4:Add, GroupBox, x3 y0 w694 h93 +BackgroundTrans,
Gui, re4:Add, Edit, x100 y40 w500 h20
Gui, re4:Add, DropDownList, x100 y65 w500 h100, 1|2|3|4|5
Gui, re4:Add, Hotkey, x20 y40 w73 h20
Gui, re4:Add, Button, x3 y96 w694 h40, Сохранить
Gui, re4:Show, w700 h140, Пожелать приятной игры
return
; #######################################################[МЕТКИ]##################################################################
RulesForAdministrationURL:
Run, http://forum.monser.ru/index.php?threads/%D0%9E%D0%B1%D1%89%D0%B8%D0%B5-%D0%BF%D1%80%D0%B0%D0%B2%D0%B8%D0%BB%D0%B0-%D0%B4%D0%BB%D1%8F-%D0%B0%D0%B4%D0%BC%D0%B8%D0%BD%D0%B8%D1%81%D1%82%D1%80%D0%B0%D1%86%D0%B8%D0%B8.63/
return
PunishmentTableURL:
Run, http://forum.monser.ru/index.php?threads/%D0%A2%D0%B0%D0%B1%D0%BB%D0%B8%D1%86%D0%B0-%D0%BD%D0%B0%D0%BA%D0%B0%D0%B7%D0%B0%D0%BD%D0%B8%D0%B9.87/
return
LogClose:
Gui, Log:Destroy
return
PunishmentTableClose:
Gui, PunishmentTable:Destroy
return
RulesForAdministrationClose:
Gui, RulesForAdministration:Destroy
return
RulesForAdministrationCommonClose:
Gui, RulesForAdministrationCommon:Destroy
return
RulesForAdministrationRecoveryClose:
Gui, RulesForAdministrationRecovery:Destroy
return
RulesForAdministrationWarnClose:
Gui, RulesForAdministrationWarn:Destroy
return
RulesForAdministrationDismissalClose:
Gui, RulesForAdministrationDismissal:Destroy
return
ChatBanTableClose:
Gui, ChatBanTable:Destroy
return
ContactUs:
Run, https://vk.com/six_slx_six
return
ReloadScript:
Reload
GuiClose:
ExitApp
return