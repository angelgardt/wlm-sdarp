---
type:
  - book
editor: Required
title: Required
publisher: Required
year: Required
edition:
address:
volume:
number:
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
> Шаблон `book` в варианте Editors используется для отдельно изданных монографий или учебников, книг, составленных редакторами, которые изданы как единое целое.

^a7ded6

> [!info] Описание полей
> `type` — тип (`book`), выставлен автоматически
> **Обязательные поля**
> `editor` — редактор(ы), составитель(и) книги
> `title` — название книги
> `publisher` — издатель книги
> `year` — год издания
> **Стандартные необязательные поля**
> `edition` — номер издания
> `address` — город, где была издана книга
> `volume` — том (при публикации книги в нескольких томах)
> `number` — номер (в серии)
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
