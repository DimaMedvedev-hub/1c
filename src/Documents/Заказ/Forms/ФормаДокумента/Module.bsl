
Перем РезультатПроверки;
Перем КоличествоНоменклатуры;



&НаКлиенте
Процедура ТоварыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	Итог = 0;
	Для каждого элемент из Объект.Товары Цикл
		Сумма = Элемент.Сумма;
		Итог = Сумма+Итог;	
		
	КонецЦикла;
	
	
	Объект.ИтоговаяСумма = Итог;	
	Итог = 0
КонецПроцедуры

&НаКлиенте
Процедура РассчетСуммНоменклатуры(Элемент)
	Строка = Элементы.Товары.ТекущиеДанные;
	Строка.Сумма = Строка.Количество*Строка.ЦенаЕденицы;	
КонецПроцедуры

&НаСервере
Процедура ОбращениеКОбщемуМодулю(Номенклатура, Цена, ТребуемоеЗначение)
	
	
	УзнатьЦенуТовара(Номенклатура,Цена,ТребуемоеЗначение);
КонецПроцедуры

&НаКлиенте
Процедура РаботаСНоменклатурой(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	Номенклатура = Текст;
	Цена = NULL;
	ТребуемоеЗначение = "Розничная";
	
	ОбращениеКОбщемуМодулю(Номенклатура, Цена, ТребуемоеЗначение);
	Строка = Элементы.Товары.ТекущиеДанные;
	Строка.ЦенаЕденицы = Цена; 
	ТребуемоеЗначение = "Закупочная";
	ОбращениеКОбщемуМодулю(Номенклатура, Цена, ТребуемоеЗначение); 
	Строка.ЗакупочнаяЦена = Цена;
	
	РезультатПроверки = NULL;
	КоличествоНоменклатуры = NULL;
	ПроверкаОстатков.ПроверкаОстатков(Номенклатура,РезультатПроверки,КоличествоНоменклатуры);
	Если РезультатПроверки = NULL или РезультатПроверки = "Нет" тогда
		
		
		Текст = "Номенклатуры нет в наличии!Выберите другое наименование";
		Поле="Номенклатура";
		СообщенияОбОшибке(Поле,Текст);
		
		Иначе Если РезультатПроверки = "Есть" тогда
			Сообщить(  "В наличии "+КоличествоНоменклатуры+" Штук");
		КонецЕсли;
	КонецЕсли
	
	
КонецПроцедуры

&НаКлиенте
Процедура СозданиеФормыЗадачаКурьеру(Отказ, ПараметрыЗаписи)
	Если Строка(Объект.СпособПолучения) = "Доставка" тогда
		ЗадачаКурьер = NULL;
		
		
		
		ФИО = Объект.ФИО_клиента;
		Адрес = Объект.АдресДоставки;
		Дата = Объект.ДатаИВремяДоставки;
		Тел = Объект.Телефон;
		Сдача = Объект.СдачаДляКурьеров;
		Итог = Объект.ИтоговаяСумма;
		
		
		Если НЕ ПустаяСтрока(ФИО) И не ПустаяСтрока(Адрес)
			И не ПустаяСтрока(Дата)И не ПустаяСтрока(Тел) 
			И не ПустаяСтрока(Сдача)И не ПустаяСтрока(Итог) Тогда
			Форма = ПолучитьФорму("Документ.ЗадачаКурьеру.Форма.ФормаДокумента");
			Форма.Объект.ФИО_клиента1 = ФИО;
			Форма.Объект.АдресДоставки1 = Адрес;
			Форма.Объект.ДатаИВремяДоставки1 = Дата;
			Форма.Объект.Телефон1 = Тел;
			Форма.Объект.СдачаДляКурьеров1 = Сдача;
			Форма.Объект.ИтоговаяСумма1 = Итог;
			Форма.Открыть();
			
			
			
		Иначе
			Сообщить("Заполните все данные!");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ФИО_клиентаОбработкаВыбораНаСервере(ВыбранноеЗначение,Телефон,Мейл)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Клиенты.Наименование КАК Наименование,
	|	Клиенты.Телефон КАК Телефон,
	|	Клиенты.email КАК email
	|ИЗ
	|	Справочник.Клиенты КАК Клиенты
	|ГДЕ
	|	Клиенты.Наименование = &Наименование";
	
	Запрос.УстановитьПараметр("Наименование", Строка(ВыбранноеЗначение));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		Мейл = ВыборкаДетальныеЗаписи.email;
		
		Телефон = ВыборкаДетальныеЗаписи.Телефон;
		
		
	КонецЦикла;
	
	
	
КонецПроцедуры

&НаКлиенте
Процедура ФИО_клиентаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ФИО = ВыбранноеЗначение;
	Телефон = NULL;
	Мейл = NULL;//Код = ВыбранноеЗначение.Код;
	ФИО_клиентаОбработкаВыбораНаСервере(ВыбранноеЗначение,Телефон,Мейл);
	Объект.Телефон = Телефон;
	Объект.email = Мейл;
	
	
КонецПроцедуры


