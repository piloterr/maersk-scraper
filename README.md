<p align="center">
  <a href="https://www.piloterr.com"><img src="images/banner.png" alt="Maersk Scraper API by Piloterr – scrape Maersk data as JSON" width="100%"></a>
</p>

# Maersk Scraper API

[![Discord](https://img.shields.io/badge/Discord-Join%20the%20community-5865F2?logo=discord&logoColor=white)](https://discord.gg/CFj3ph8aHU) [![Get API key](https://img.shields.io/badge/Piloterr-Get%20a%20free%20API%20key-111827)](https://app.piloterr.com) [![API docs](https://img.shields.io/badge/Docs-OpenAPI-0EA5E9)](https://app.piloterr.com/openapi) [![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

The **Piloterr Maersk Scraper API** lets you extract public data from Maersk as **clean, structured JSON** — no proxies, headless browsers or HTML parsing to maintain. Endpoints available in production:

- **Maersk Tracking API** — Track a Maersk container or BOL: origin, destination, current milestone and full transport-plan events via browser rendering.

Use it for price tracking, review and reputation monitoring, local market research or logistics tracking.

| Endpoint | Path | Credits | What you get |
|---|---|---|---|
| [Maersk Tracking API](#maersk-tracking-api) | `/v2/maersk/tracking` | 2 | Track a Maersk container or BOL |

## Table of contents

- [How it works](#how-it-works)
- [Maersk Tracking API](#maersk-tracking-api)
- [Code examples in other languages](#code-examples-in-other-languages)
- [Practical use cases](#practical-use-cases)
- [Why Piloterr?](#why-piloterr)
- [FAQ](#faq)
- [Related scrapers](#related-scrapers)
- [Support](#support)

## How it works

1. **Create a free Piloterr account** and copy your API key from the [dashboard](https://app.piloterr.com).
2. **Send a `GET` (or `POST`) request** to `https://api.piloterr.com/v2/...` with the header `x-api-key: YOUR_API_KEY`.
3. **Receive structured JSON** — Piloterr handles rendering, proxies, retries and parsing.

```bash
export PILOTERR_API_KEY="your-api-key"
pip install requests        # Python
# TypeScript: Node.js 18+ (native fetch), run with `npx tsx file.ts`
```

> Every endpoint accepts both `GET` (query string) and `POST` (JSON body with the same fields).

## Maersk Tracking API

Track a Maersk container or BOL: origin, destination, current milestone and full transport-plan events via browser rendering.

`GET | POST https://api.piloterr.com/v2/maersk/tracking` · **2 credits per request** · [Full reference](https://app.piloterr.com/openapi)

### Request parameters

| Parameter | Type | Required | Description |
|---|---|---|---|
| `query` | string | ✅ | Container / BOL tracking number, or full Maersk tracking URL. |
| `return_page_source` | boolean | — | When `true`, return the rendered HTML as `{"result": "..."}` instead of structured JSON. Defaults to `false`. |

### Python example

```python
import json
import os
import requests

response = requests.get(
    "https://api.piloterr.com/v2/maersk/tracking",
    headers={"x-api-key": os.environ["PILOTERR_API_KEY"]},
    params={
        "query": "MMAU1155207",
    },
    timeout=120,
)
response.raise_for_status()
data = response.json()

print(json.dumps(data, indent=2, ensure_ascii=False)[:2000])
```

### TypeScript example

```typescript
type MaerskTracking = {
  url?: string;
  events?: {
    date?: string;
    event?: string;
    location?: {
      city?: string;
      facility?: string;
    };
    position?: number;
    is_current?: boolean;
  }[];
  origin?: string;
  destination?: string;
  current_event?: {
    date?: string;
    event?: string;
    position?: number;
    is_current?: boolean;
  };
  tracking_type?: string;
  tracking_number?: string;
};

const params = new URLSearchParams({
  "query": "MMAU1155207",
});

const response = await fetch(`https://api.piloterr.com/v2/maersk/tracking?${params}`, {
  headers: { "x-api-key": process.env.PILOTERR_API_KEY! },
});
if (!response.ok) throw new Error(`Piloterr error ${response.status}: ${await response.text()}`);

const data = (await response.json()) as MaerskTracking;

console.log(JSON.stringify(data, null, 2).slice(0, 2000));
```

<details>
<summary><b>POST variant</b></summary>

```http
POST https://api.piloterr.com/v2/maersk/tracking
x-api-key: YOUR_API_KEY
Content-Type: application/json

{"query": "MMAU1155207"}
```
</details>

### Output example

Example response from the API reference, abridged — real values depend on the page you scrape.

```json
{
  "url": "https://www.maersk.com/tracking/MMAU1155207",
  "events": [
    {
      "date": "23 Mar 2026 16:29",
      "event": "Gate out Empty",
      "location": {
        "city": "Paranagua",
        "facility": "Maersk Depot Paranagua"
      },
      "position": 1,
      "is_current": false
    },
    {
      "date": "02 Apr 2026 18:49",
      "event": "Load on MAERSK LOTA / 614N",
      "vessel": "MAERSK LOTA / 614N",
      "position": 3,
      "is_current": false
    }
  ],
  "origin": "PARANAGUA",
  "destination": "AL KHOMS",
  "current_event": {
    "date": "02 Jun 2026 14:00",
    "event": "Empty container return",
    "position": 16,
    "is_current": true
  },
  "tracking_type": "Container",
  "tracking_number": "MMAU1155207"
}
```

### Response fields

| Field | Type | Description |
|---|---|---|
| `url` | string |  |
| `events[]` | object[] |  |
| `events[].date` | string |  |
| `events[].event` | string |  |
| `events[].location` | object |  |
| `events[].position` | integer |  |
| `events[].is_current` | boolean |  |
| `origin` | string |  |
| `destination` | string |  |
| `current_event` | object |  |
| `current_event.date` | string |  |
| `current_event.event` | string |  |
| `current_event.position` | integer |  |
| `current_event.is_current` | boolean |  |
| `tracking_type` | string |  |
| `tracking_number` | string |  |

## Code examples in other languages

Ready-to-run examples live in the [`examples/`](examples) folder. Each one reads your key from the `PILOTERR_API_KEY` environment variable.

| Language | Tracking |
|---|---|
| cURL (Bash) | [`tracking`](examples/curl/tracking.sh) |
| PHP | [`tracking`](examples/php/tracking.php) |
| C# | [`tracking`](examples/csharp/Tracking.cs) |
| Go | [`tracking`](examples/go/tracking.go) |
| Java | [`tracking`](examples/java/TrackingExample.java) |
| Ruby | [`tracking`](examples/ruby/tracking.rb) |
| Node.js | [`tracking`](examples/nodejs/tracking.mjs) |

## Practical use cases

- **Price tracking** — Monitor rates and offers over time.
- **Reputation monitoring** — Track ratings and reviews of venues and competitors.
- **Local market research** — Map businesses, venues and events by area.
- **Logistics visibility** — Follow shipments and statuses where available.
- **Travel products** — Power comparison tools and alerts with structured data.

## Why Piloterr?

- **No infrastructure** — no proxies, headless browsers or CAPTCHA solving to run yourself.
- **Structured JSON** — stable, documented fields instead of brittle HTML selectors.
- **Pay per request** — transparent credit cost per endpoint, failed requests are retried for you.
- **One API key, hundreds of sources** — Maersk plus many other e-commerce, search and company data endpoints in the [Piloterr library](https://www.piloterr.com/library).
- **Any language** — plain HTTPS + JSON, with examples for Python, TypeScript, cURL, PHP, C#, Go, Java, Ruby and Node.js.

## FAQ

### Is it legal to scrape Maersk?

Collecting publicly available data is generally allowed in many jurisdictions, but rules depend on your country, the data you collect and how you use it. Avoid personal data unless you have a lawful basis, respect the website's terms where they apply, and get legal advice for your specific use case. This is not legal advice.

### Do I need proxies or a headless browser?

No. Piloterr handles rendering, proxy rotation and retries on its side. You only send an HTTPS request with your `x-api-key` header and receive JSON.

### How much does a request cost?

Credits per call: `/v2/maersk/tracking` **2**. See the [Piloterr website](https://www.piloterr.com) for plans.

### What data does the Maersk API return?

Each endpoint returns structured JSON: **Maersk Tracking** — `url`, `events[]`, `events[].date`, `events[].event`, `events[].location`, `events[].position`.

### Can I get the raw HTML instead of JSON?

Yes. Set `return_page_source=true` and the response becomes `{"result": "..."}` with the page source.

### Which languages are supported?

Any language that can make an HTTP request. This README shows Python and TypeScript; the [`examples/`](examples) folder contains cURL, PHP, C#, Go, Java, Ruby and Node.js.

## Related scrapers

- [Auto Europe Scraper API](https://github.com/piloterr/autoeurope-scraper)
- [Eventbrite Scraper API](https://github.com/piloterr/eventbrite-scraper)
- [Expedia Scraper API](https://github.com/piloterr/expedia-scraper)
- [TheFork Scraper API](https://github.com/piloterr/thefork-scraper)
- [Yelp Scraper API](https://github.com/piloterr/yelp-scraper)
- [All Piloterr scrapers on GitHub](https://github.com/piloterr)

## Support

- 💬 Join the [Piloterr Discord](https://discord.gg/CFj3ph8aHU) to ask questions and share what you build.
- 📚 Browse the [API reference (OpenAPI)](https://app.piloterr.com/openapi) and the [Piloterr library](https://www.piloterr.com/library).
- 🔑 [Get your API key](https://app.piloterr.com).

---

<p align="center">
  <a href="https://www.piloterr.com">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="images/logo-dark.svg">
      <img src="images/logo.svg" alt="Piloterr" height="32">
    </picture>
  </a>
  <br>
  <sub>Built by <a href="https://www.piloterr.com">Piloterr</a> — web scraping APIs for e-commerce, search, real estate and more, one API key.</sub>
</p>

<sub>Maersk is a trademark of its respective owner. This repository is not affiliated with or endorsed by Maersk. Examples are released under the MIT license.</sub>
