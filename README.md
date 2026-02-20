<div align="center">
  <img src="screenshots/registration.png" alt="WishGift" width="120" style="border-radius: 30px"/>

  # 🎁 WishGift

  > Создавай вишлисты, зови друзей, получай именно то, что хочешь

  ![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20Android-blueviolet?style=for-the-badge&logo=flutter&logoColor=white)
  ![Language](https://img.shields.io/badge/Dart%20%2F%20Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
  ![Database](https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)
  ![Architecture](https://img.shields.io/badge/Clean%20Architecture-6C3483?style=for-the-badge)
  ![l10n](https://img.shields.io/badge/l10n-EN%20%7C%20RU-FF6B35?style=for-the-badge)

</div>

---

## 📱 Screenshots

<div align="center">

<table>
  <tr>
    <td align="center">
      <img src="screenshots/registration.png" width="190" alt="Splash"/>
      <br/><b>Splash Screen</b>
      <br/><sub>Приветственный экран</sub>
    </td>
    <td align="center">
      <img src="screenshots/hello.png" width="190" alt="Онбординг"/>
      <br/><b>Онбординг</b>
      <br/><sub>Зови друзей, создавай вишлисты</sub>
    </td>
    <td align="center">
      <img src="screenshots/home.png" width="190" alt="Главная"/>
      <br/><b>Главная</b>
      <br/><sub>Мои желания и вишлисты</sub>
    </td>
    <td align="center">
      <img src="screenshots/info.png" width="190" alt="Карточка желания"/>
      <br/><b>Карточка желания</b>
      <br/><sub>Цена, ссылки, магазины</sub>
    </td>
  </tr>
</table>

</div>

---

## ✨ Возможности

**🎀 Вишлисты** — создавай тематические списки желаний (Рождество, День рождения, Мечты и т.д.)

**👫 Совместный доступ** — приглашай друзей, они бронируют подарки и видят, что уже занято

**🛍 Карточка желания** — фото, цена, ссылки на магазины где можно купить

**📊 Статистика** — отслеживай сколько желаний исполнено, сколько забронировано

**🌍 Локализация (l10n)** — поддержка русского и английского языков через официальный Flutter l10n

---

## 🏗 Архитектура

Проект построен по принципам **Clean Architecture** с разделением на слои:

```
lib/
├── core/
│   ├── error/              # Обработка ошибок
│   ├── platform/           # Платформенные абстракции
│   └── usecases/           # Базовые usecase'ы
├── feature/
│   ├── data/
│   │   ├── datasource/     # Supabase / Local источники данных
│   │   ├── models/         # DTO модели
│   │   └── repositories/   # Реализации репозиториев
│   ├── domain/
│   │   ├── entities/       # Бизнес-сущности
│   │   ├── repositories/   # Абстракции репозиториев
│   │   └── usecases/       # Бизнес-логика
│   └── presentation/
│       ├── cubit/          # Управление состоянием
│       ├── pages/          # Экраны
│       └── widgets/        # UI компоненты
└── l10n/
    ├── app_en.arb          # Английская локализация
    └── app_ru.arb          # Русская локализация
```

---

## 🛠 Tech Stack

| Слой | Технологии |
|------|-----------|
| **Language** | Dart / Flutter |
| **State Management** | Cubit (flutter_bloc) |
| **DI** | get_it |
| **Architecture** | Clean Architecture (UseCase, Repository pattern) |
| **Database** | Supabase |
| **Localization** | Flutter l10n (официальная) |
| **Platform** | iOS & Android |

---

## 🚀 Установка и запуск

```bash
# Клонируй репозиторий
git clone https://github.com/a4ifka/wishgift.git
cd wishgift

# Установи зависимости
flutter pub get

# Сгенерируй локализацию
flutter gen-l10n

# Запусти
flutter run
```

Добавь в `main.dart` или `lib/main.dart`:

```dart
  await Supabase.initialize(
    url: 'URL',
    anonKey:
        'API_KEY',
  );
```

---

## 📦 Ключевые зависимости

```yaml
dependencies:
  flutter_bloc: # Cubit для управления состоянием
  get_it:        # Dependency Injection
  supabase_flutter: # База данных
  flutter_localizations: # l10n
```

---

<div align="center">

Made with 🎀 by [a4ifka](https://github.com/a4ifka) & [Epl-Grey](https://github.com/Epl-Grey)

</div>