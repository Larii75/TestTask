//BSD 3-Clause License

//Copyright (c) 2021, Andrii Linchenko
//All rights reserved.

//Redistribution and use in source and binary forms, with or without
//modification, are permitted provided that the following conditions are met:

//1. Redistributions of source code must retain the above copyright notice, this
//   list of conditions and the following disclaimer.

//2. Redistributions in binary form must reproduce the above copyright notice,
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.

//3. Neither the name of the copyright holder nor the names of its
//   contributors may be used to endorse or promote products derived from
//   this software without specific prior written permission.

//THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
//FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
//OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Процедура ОбработкаПроведения(Отказ, Режим)

	Для Каждого Движение Из Движения Цикл
		Движение.БлокироватьДляИзменения = Истина;
		Движение.Записывать = Истина;
		Движение.Очистить();
		Движение.Записать();
		Движение.Записывать = Истина;
	КонецЦикла;
	
	// регистр ТоварыНаСкладах Приход
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ПриходнаяТовары.Номенклатура КАК Номенклатура,
	               |	ПриходнаяТовары.Количество КАК Количество,
	               |	ПриходнаяТовары.Сумма КАК Сумма
	               |ИЗ
	               |	Документ.Приходная.Товары КАК ПриходнаяТовары
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СправочникНоменклатура
	               |		ПО ПриходнаяТовары.Номенклатура = СправочникНоменклатура.Ссылка
	               |ГДЕ
	               |	ПриходнаяТовары.Ссылка = &Ссылка
	               |	И СправочникНоменклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар)";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Движение = Движения.ТоварыНаСкладах.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Период = Дата;
		Движение.Склад = Склад;
		Движение.Номенклатура = Выборка.Номенклатура;
		Движение.Количество = Выборка.Количество;
		Движение.Сумма = Выборка.Сумма;
		Движение.Партия = Ссылка;
	КонецЦикла;
	
КонецПроцедуры
