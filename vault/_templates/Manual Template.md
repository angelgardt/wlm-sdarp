---
type:
  - manual
title: Required
year: Required
author:
organization:
address:
edition:
subtitle:
month:
note:
url:
doi:
issn:
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
> Шаблон `manual` используется для технической документации, руководств пользователя, описаний программных продуктов, документации к оборудованию, user manuals, инструкций.

^5d1037

> [!info] Описание полей
> `type` — тип (`manual`), выставлен автоматически
> **Обязательные поля**
> `title` — название мануала
> `year` — год издания
> **Стандартные необязательные поля**
> `author` — автор(ы) мануала
> `organization` — организация, ответственная за издание мануала
> `address` — город, где была издана книга
> `edition` — номер издания
> **Нестандартные поля**
> `subtitle` — подзаголовок книги (встречается чаще чем для статей)
> `month` — месяц публикации книги
> `note` — дополнительная информация
> `url` — ссылка на сайт, где найдена книга
> `doi` — идентификатор публикации (digital object identifier)
> `issn` — идентификатор публикации (international standard serial number)
> `citekey` — ключ, используемый для цитирования в проекте
> `filename` — название файла в главном хранилище (`THE VAULT`)
> `tags` — теги, для поиска и структурирования

***
## Почему используется как источник

## Что конкретно цитируется
