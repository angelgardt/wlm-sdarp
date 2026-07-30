---
type:
  - booklet
title: Required
author:
  - Required
howpublished: Required
address: Required
year: Required
editor:
volume:
number:
subtitle:
series:
organization:
month:
note:
url:
doi:
citekey:
filename:
tags:
---
## BibTex Entry
```dataviewjs
const p = dv.current();
const type = p.type || "misc";
const citekey = p.citekey || p.file.name;

let bib = `@${type}{${citekey},\n`;
const ignoreKeys = ['file', 'type', 'citekey', 'filename', 'tags'];

for (const [key, value] of Object.entries(p)) {
	if (ignoreKeys.includes(key) || value === null || value === undefined) continue;
	// Обработка массивов (например, если авторов несколько: author: [Иванов, Петров])
	let valStr = Array.isArray(value) ? value.join(" and ") : String(value);
	bib += ` ${key} = {${valStr}},\n`;
}
bib += `}`;

// Рендерим результат в виде блока кода с подсветкой
const pre = dv.container.createEl("pre");
const code = pre.createEl("code", { cls: "language-bibtex" });
code.textContent = bib;
```
***
## Template Description
> [!info] Использование шаблона
> Шаблон `booklet` используется для того, что опубликовано почти как книга, но не является книгой — самиздата, небольших отчетов, программ конференций или буклетов, у которых нет ISBN и четкого издателя.

^5d1037

> [!info] Описание полей
> `type` — тип (`booklet`), выставлен автоматически
> **Обязательные поля**
> `title` — название публикации
> `author` — автор(ы) публикации
> `howpublished` — способ публикации
> `address` — город, где была издана публикация
> `year` — год издания
> **Стандартные необязательные поля**
> `editor` — редактор(ы) публикации
> `volume` — том (в серии)
> `number` — номер (в серии)
> **Нестандартные поля**
> `subtitle` — подзаголовок книги (встречается чаще чем для статей)
> `series` — название серии, в которой издана книга
> `month` — месяц публикации книги
> `note` — дополнительная информация
> `url` — ссылка на сайт, где найдена книга
> `doi` — идентификатор публикации (digital object identifier)
> `citekey` — ключ, используемый для цитирования в проекте
> `filename` — название файла в главном хранилище (`THE VAULT`)
> `tags` — теги, для поиска и структурирования

***
## Почему используется как источник

## Что конкретно цитируется
