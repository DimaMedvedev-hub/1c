перем АдресВХранилище экспорт;
&НаКлиенте
Процедура ДобавитьИзСпискаЗадач(Команда)
	
	ПолучитьФорму("Документ.МаршрутныйЛист.Форма.Форма").Открыть();
	КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Ключ = Новый УникальныйИдентификатор();
	    ЭтаФорма.КлючУникальности = Ключ;
		АдресВХранилище = ПоместитьВоВременноеХранилище(Ключ);
КонецПроцедуры
