document.addEventListener('DOMContentLoaded', () => {
  const LEVELS = {
    'lab-novice': 'Novice',
    'lab-junior': 'Junior',
    'lab-senior': 'Senior',
    'lab-expert': 'Expert'
  };


// 1. Создаём контейнер кнопок
const container = document.createElement('div');
container.id = 'lab-level-filters';
container.setAttribute('role', 'group');
container.setAttribute('aria-label', 'Фильтр по уровню сложности разделов')



const buttons = {};
const activeState = {};

// Восстанавливаем состояние из sessionStorage или ставим true по умолчанию
const savedState = JSON.parse(sessionStorage.getItem('labLevelFilter') || '{}');


for (const [cls, label] of Object.entries(LEVELS)) {
  const btn = document.createElement('button');
  btn.className = 'lab-filter-btn';
  btn.textContent = label;
  btn.dataset.level = cls;

  // По умолчанию всё включено, если нет сохранённого состояния
  const isActive = savedState[cls] !== undefined ? savedState[cls] : true;
  activeState[cls] = isActive;

  btn.classList.toggle('active', isActive);
  btn.classList.toggle('inactive', !isActive);
  btn.setAttribute('aria-pressed', String(isActive));

  container.appendChild(btn);
  buttons[cls] = btn;
}

// 2. Вставляем контейнер после заголовка главы (или в начало main)
const titleEl = document.querySelector('h1.title, header h1, .page-header h1');
const mainEl = document.querySelector('main') || document.querySelector('.quarto-body') || document.body;

if (titleEl) {
  titleEl.insertAdjacentElement('afterend', container);
} else {
  mainEl.prepend(container);
}

// 3. Проверяем наличие разделов на странице

for (const cls of Object.keys(LEVELS)) {
  const exists = document.querySelector(`section.${cls}`) !== null;
  if (!exists) {
    buttons[cls].classList.add('hidden');
  }
}

// 4. Логика переключения
  for (const cls of Object.keys(LEVELS)) {
    buttons[cls].addEventListener('click', () => {
      const isActive = !activeState[cls];
      activeState[cls] = isActive;

      // Обновляем UI
      buttons[cls].classList.toggle('active', isActive);
      buttons[cls].classList.toggle('inactive', !isActive);
      buttons[cls].setAttribute('aria-pressed', String(isActive));

      // Сохраняем состояние
      sessionStorage.setItem('labLevelFilter', JSON.stringify(activeState));

      // Показываем/скрываем разделы
      document.querySelectorAll(`section.${cls}`).forEach(section => {
        if (isActive) {
          section.classList.remove('hidden');
        } else {
          section.classList.add('hidden');
        }
      });
    });
  };
