---
type:
  - inbook
author: Required
title: Required
booktitle: Required
publisher: Required
year: Required
pages:
edition:
address:
volume:
number:
editor:
subtitle:
series:
month:
note:
url:
doi:
issn:
isbn:
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
> Шаблон `inbook` используется для части цельной книги (монографии) — главы, раздела, тома — имеющей свое собственное название и, возможно, своего автора.

^5d1037

> [!info] Описание полей
> `type` — тип (`inbook`), выставлен автоматически
> **Обязательные поля**
> `author` — автор(ы) главы (раздела) книги
> `title` — название главы (раздела) книги
> `booktitle` — название книги, содержащей главу (раздел)
> `publisher` — издатель книги
> `year` — год издания
> **Стандартные необязательные поля**
> `pages` — страницы, на которых напечатана глава (раздел)
> `edition` — номер издания
> `address` — город, где была издана книга
> `volume` — том (в серии)
> `number` — номер (в серии)
> `editor` — редактор(ы) книги
> **Нестандартные поля**
> `subtitle` — подзаголовок книги (встречается чаще чем для статей)
> `series` — название серии, в которой издана книга
> `month` — месяц публикации книги
> `note` — дополнительная информация
> `url` — ссылка на сайт, где найдена книга
> `doi` — идентификатор публикации (digital object identifier)
> `issn` — идентификатор публикации (international standard serial number)
> `isbn` — идентификатор публикации (international standard book number)
> `citekey` — ключ, используемый для цитирования в проекте
> `filename` — название файла в главном хранилище (`THE VAULT`)
> `tags` — теги, для поиска и структурирования

***
## Почему используется как источник

## Что конкретно цитируется
