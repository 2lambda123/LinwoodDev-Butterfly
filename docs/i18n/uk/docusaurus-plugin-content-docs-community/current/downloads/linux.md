---
title: "Linux"
sidebar_position: 3
---

```mdx-code-block
імпортувати кнопку завантаження з '@site/src/components/DownloadButton.tsx';
```

![стабільна версія](https://img.shields.io/badge/dynamic/yaml?color=c4840d&label=Stable&query=%24.version&url=https%3A%2F%2Fraw.githubusercontent.com%2FLinwoodDev%2Fbutterfly%2Fstable%2Fapp%2Fpubspec.yaml&style=for-the-badge) ![Нічна версія](https://img.shields.io/badge/dynamic/yaml?color=f7d28c&label=Nightly&query=%24.version&url=https%3A%2F%2Fraw.githubusercontent.com%2FLinwoodDev%2Fbutterfly%2Fnightly%2Fapp%2Fpubspec.yaml&style=for-the-badge)

::note

Будь ласка, використовуйте версію flatpak, якщо можливо. В іншому випадку вам необхідно встановити `libsecret-1-dev` та `libjsoncpp-dev`.

:::

## Двійкові файли

<div className="row margin-bottom--lg padding--sm">
<div className="dropdown dropdown--hoverable margin--sm">
  <button className="button button--outline button--info button--lg">Стабільний</button>
  <ul className="dropdown__menu">
    <li>
      <DownloadButton className="dropdown__link" href="https://github.com/LinwoodDev/butterfly/releases/download/stable/linwood-butterfly-linux.tar.gz">
        Портативний
      </DownloadButton>
    </li>
    <li>
      <DownloadButton className="dropdown__link" href="https://github.com/LinwoodDev/butterfly/releases/download/stable/linwood-butterfly-linux.deb">
        ДЕБ
      </DownloadButton>
    </li>
    <li>
      <DownloadButton className="dropdown__link" href="https://github.com/LinwoodDev/butterfly/releases/download/stable/linwood-butterfly-linux.AppImage">
        AppImage
      </DownloadButton>
    </li>
  </ul>
</div>
<div className="dropdown dropdown--hoverable margin--sm">
  <button className="button button--outline button--danger button--lg">Нічна</button>
  <ul className="dropdown__menu">
    <li>
      <DownloadButton className="dropdown__link" href="https://github.com/LinwoodDev/butterfly/releases/download/nightly/linwood-butterfly-linux.tar.gz">
        Портативний
      </DownloadButton>
    </li>
    <li>
      <DownloadButton className="dropdown__link" href="https://github.com/LinwoodDev/butterfly/releases/download/nightly/linwood-butterfly-linux.deb">
        ДЕБ
      </DownloadButton>
    </li>
    <li>
      <DownloadButton className="dropdown__link" href="https://github.com/LinwoodDev/butterfly/releases/download/nightly/linwood-butterfly-linux.rpm">
        RPM
      </DownloadButton>
    </li>
    <li>
      <DownloadButton className="dropdown__link" href="https://github.com/LinwoodDev/butterfly/releases/download/nightly/linwood-butterfly-linux.AppImage">
        AppImage
      </DownloadButton>
    </li>
  </ul>
</div>
</div>

Дізнайтеся більше про нічну версію Butterfly [тут](/nightly).

## Магазини

<div className="row margin-bottom--lg padding--sm">
<a className="button button--outline button--primary button--lg margin--sm" href="https://flathub.org/apps/details/dev.linwood.butterfly">
  Зсув
</a>
<a className="button button--outline button--primary button--lg margin--sm" href="https://snapcraft.io/butterfly">
  Приліпити
</a>
<a className="button button--outline button--primary button--lg margin--sm" href="https://snapcraft.io/butterfly">
  Snap
</a>
</div>

Нічна версія також доступна на Flathub beta репозиторії. Read more about the flathub beta repository [here](https://discourse.flathub.org/t/how-to-use-flathub-beta/2111).
