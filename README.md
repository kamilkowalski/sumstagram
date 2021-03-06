
<img src="logo.png" height="86" alt="Sumstagram Logo" />

Warsztaty mające na celu naukę tworzenia API przy pomocy frameworka Ruby on Rails.
System, który będziemy tworzyć to okrojona implementacja Instagrama. Całość
przygotowana na zajęcia projektowe specjalizacji
[Sieci Urządzeń Mobilnych](https://www.facebook.com/Sieci-Urz%C4%85dze%C5%84-Mobilnych-211004225604000/)
przy [Polsko-Japońskiej Akademii Technik Komputerowych](http://pja.edu.pl/).

**Tekst warsztatów dostępny pod adresem: https://kamilkowalski.gitbooks.io/sumstagram-api/content/**

## Dokumentacja API

W ramach API stworzymy poniższe endpointy/zasoby. W ramach każdego zasobu
zdefiniujemy przykładowe zapytania i możliwe odpowiedzi (wraz z kodami HTTP).

### `POST /users`

Tworzy nowego użytkownika i zwraca nam token autoryzacyjny do dalszego działania,
albo błąd w przypadku gdy:
* Nazwa użytkownika jest pusta bądź zajęta
* E-mail jest pusty, niepoprawny bądź zajęty
* Hasło jest puste bądź za krótkie

#### Przykładowe zapytanie
```json
{
  "username": "kamilk",
  "email": "kamil@kamilkowalski.pl",
  "password": "xxxxxxxxxxxx"
}
```

#### `201 Created`
```json
{
  "access_token": {
    "code": "0123456789",
    "expires_at": "2016-12-11T11:34:00.148Z"
  }
}
```

#### `400 Bad Request`
```json
{
  "errors": [
    "Nazwa użytkownika jest zajęta",
    "E-mail jest zajęty"
  ]
}
```

### `POST /access_tokens`

Tworzy i zwraca nowy token użytkownika na podstawie emaila/loginu
i hasła użytkownika. Obsługujemy zarówno logowanie przez email
jak i przez login, ale wymagane jest żeby chociaż jeden z tych
kluczy się pojawił. Jeżeli zostaną przesłane oba to użyty będzie
adres email.

#### Przykładowe zapytanie
```json
{
  "username": "kamilk",
  "password": "xxxxxxxxxxxxx"
}
```

#### `201 Created`
```json
{
  "access_token": {
    "code": "0123456789",
    "expires_at": "2016-12-11T22:12:00.148Z"
  }
}
```

#### `401 Unauthorized`
```json
{
  "errors": [
    "Niepoprawne hasło dla podanego użytkownika"
  ]
}
```

#### `404 Not Found`
```json
{
  "errors": [
    "Nie znaleziono podanego użytkownika"
  ]
}
```

### `PATCH /access_tokens`

Odświeża token autoryzacyjny na podstawie starego tokenu. Jeżeli nie
mamy starego tokenu, lub stary token nie jest już aktywny,
powinniśmy użyć zasobu `POST /access_tokens`.

#### Przykładowe zapytanie
```json
{
  "access_token": "0123456789"
}
```

#### `200 OK`
```json
{
  "access_token": {
    "code": "9876543210",
    "expires_at": "2017-01-14T11:43:33.148Z"
  }
}
```

#### `401 Unauthorized`
```json
{
  "errors": [
    "Token autoryzacyjny wygasł"
  ]
}
```

#### `400 Bad Request`
```json
{
  "errors": [
    "Musisz podać token autoryzacyjny"
  ]
}
```

### `POST /photos`

Dodaje nowe zdjęcie. Zdjęcie jest przekazane jako atrybut w dokumencie JSON
przesłanym do serwera. Zdjęcie musi być w formacie JPEG. W celu przesłania
jednego dokumentu zamiast rozbijać zapytanie na dwa osobne, kodujemy zdjęcie za
pomocą Base64. To zwiększy rozmiar zdjęcia o 33% ale ułatwi nam pracę
i zminimalizuje liczbę endpointów. Dane obrazka muszą też zawierać schemat Base64,
to jest `data:image/jpg;base64,DANE_OBRAZKA`.

#### Przykładowe zapytanie
```json
{
  "access_token": "0123456789",
  "encoded_image": "data:image/jpg;base64,Bq6D2jTssAEmiPkwIm03CVZvm11C4U96f\nMAEkSbatjTFGl1nCWVmpjTGm3obU1wf4NwsAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAC+Vf0H3Tix078qfCwAAAAASUVORK5CYII=\n",
  "comment": "Lubię #koty #cats #caturday #warsaw #warszawa #TheCakeIsALie"
}
```

#### `201 Created`
```js
// Pusta odpowiedź
```

#### `401 Unauthorized`
```json
{
  "errors": [
    "Niepoprawny token autoryzacyjny"
  ]
}
```

#### `400 Bad Request`
```json
{
  "errors": [
    "Brak danych lub niepoprawny format zdjęcia"
  ]
}
```

### `GET /photos`

Pobiera najnowsze zdjęcia wrzucone przez innych użytkowników, opcjonalnie z danego
zakresu określonego przez limit zdjęć, które powinny zostać wrzucone oraz przesunięcie
względem początku (offset). Jeżeli robimy paginację po 10 zdjęc i chcemy wyświetlić
stronę 3., to `{ limit: 10, offset: 20 }`. Domyślny limit wynosi 25.

Każde zdjęcie to obiekt z następującymi kluczami:

| Klucz      | Znaczenie                                |
|------------|------------------------------------------|
| id         | Identyfikator zdjęcia                    |
| image_url  | Adres HTTPS zdjęcia                      |
| created_at | Data utworzenia zdjęcia                  |
| author     | Informacje o autorze zdjęcia             |
| comments   | Lista pierwszych 5 komentarzy do zdjęcia |

Każdy komentarz to obiekt z następującymi kluczami:

| Klucz      | Znaczenie                                |
|------------|------------------------------------------|
| content    | Treść komentarza                         |
| created_at | Data dodania komentarza                  |
| author     | Informacje o autorze komentarza          |

Każdy autor (zdjęcia oraz komentarza) to obiekt z następującymi kluczami:

| Klucz      | Znaczenie                                |
|------------|------------------------------------------|
| username   | Nazwa użytkownika                        |

#### Przykładowe zapytanie
```json
{
  "access_token": "0123456789",
  "limit": 10,
  "offset": 20
}
```

#### `200 OK`
```json
{
  "photos": [
    {
      "id": 15,
      "image_url": "https://sumstagram-api.c9.io/cat.jpg",
      "created_at": "2016-11-13T11:41:00.148Z",
      "author": {
        "username": "kamilk"
      },
      "comments": [
        {
          "content": "Lubię #koty #cats #caturday #warsaw #warszawa #TheCakeIsALie",
          "created_at": "2016-11-13T11:41:00.148Z",
          "author": {
            "username": "kamilk"
          }
        },
        {
          "content": "Fajny kot! 😻",
          "created_at": "2016-11-14T09:00:15.148Z",
          "author": {
            "username": "ania90"
          }
        }
      ]
    }
  ]
}
```

#### `401 Unauthorized`
```json
{
  "errors": [
    "Niepoprawny token autoryzacyjny"
  ]
}
```

### `POST /photo/:id/comments`

Dodaje komentarz do zdjęcia o podanym numerze ID.

#### Przykładowe zapytanie

```json
{
  "access_token": "0123456789",
  "content": "Blee, wolę psy 🐩🐾"
}
```

#### `201 Created`
```js
// Pusta odpowiedź
```

#### `401 Unauthorized`
```json
{
  "errors": [
    "Niepoprawny token autoryzacyjny"
  ]
}
```

#### `400 Bad Request`
````json
{
  "errors": [
    "Musisz podać treść komentarza"
  ]
}
```

### `GET /photo/:id/comments`

Pobiera listę komentarzy dla zdjęcia o podanym ID. Możemy podać, jak w przypadku
listy zdjęć, parametry `limit` i `offset`, a domyślny `limit` wynosi 25.

#### Przykładowe zapytanie
```json
{
  "access_token": "0123456789",
  "limit": 15,
  "offset": 30
}
```

#### `200 OK`
```json
{
  "comments": [
    {
      "content": "Lubię #koty #cats #caturday #warsaw #warszawa #TheCakeIsALie",
      "created_at": "2016-11-13T11:41:00.148Z",
      "author": {
        "username": "kamilk"
      }
    },
    {
      "content": "Fajny kot! 😻",
      "created_at": "2016-11-14T09:00:15.148Z",
      "author": {
        "username": "ania90"
      }
    },
    {
      "content": "Blee, wolę psy 🐩🐾",
      "created_at": "2016-11-14T11:41:55.148Z",
      "author": {
        "username": "kondratk"
      }
    }
  ]
}
```

#### `401 Unauthorized`
```json
{
  "errors": [
    "Niepoprawny token autoryzacyjny"
  ]
}
```
