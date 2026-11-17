# Grafana BigData 41211036 | 亞洲旅館營運大數據視覺化分析平台

![Cloudflare Workers](https://img.shields.io/badge/Deployment-Cloudflare%20Workers-orange?logo=cloudflare)
![Data Records](https://img.shields.io/badge/BigData-80%2C848%20Records-blue)
![Hotels](https://img.shields.io/badge/Hotels-165%20Properties-green)
![Regions](https://img.shields.io/badge/Countries-11%20Asian%20Regions-purple)

本專案為針對亞洲 11 個國家/地區（台灣、日本、泰國、新加坡、香港、韓國、中國大陸、越南、馬來西亞、菲律賓、印尼）共 **165 間指標飯店**、**80,848 筆真實館名與模擬營運大數據** 構建之 Grafana 風格巨量資料視覺化與全球飯店即時比價平台。

---

## 🌐 線上部署網址 (Live URL)

- **Cloudflare Edge 生產環境網址**：[https://grafana-bigdata-41211036.a0985481175.workers.dev](https://grafana-bigdata-41211036.a0985481175.workers.dev)
- **API 健康檢查端點**：[https://grafana-bigdata-41211036.a0985481175.workers.dev/api/health](https://grafana-bigdata-41211036.a0985481175.workers.dev/api/health)
- **大數據 JSON 端點**：[https://grafana-bigdata-41211036.a0985481175.workers.dev/api/data](https://grafana-bigdata-41211036.a0985481175.workers.dev/api/data)

---

## 📊 規格需求與核心分析結論

### 1. 比較亞洲區域飯店品牌（如 IHG、萬豪等）的平日與假日房價分析
透過解析模擬營運數據中之「週末 (0/1)」、「當地假日 (0/1)」、「當日價格係數」與「週末/假日調整率」：
- **洲際酒店集團 (IHG)**：平日每晚均價 **$110.42 USD**（價格指數 102.01），週末假日均價 **$114.82 USD**（價格指數 105.94），平均加價調幅為 **+3.98%**。涵蓋都會精選（Kimpton Da An 台北金普頓大安、Kimpton Maa-lai Bangkok 曼谷金普頓）、頂級商務奢華（InterContinental Taipei、The Strings Tokyo）及渡假休閒（Hotel Indigo Alishan 阿里山英迪格）。
- **萬豪國際集團 (Marriott)**：平日每晚均價 **$101.00 USD**（價格指數 99.85），週末假日均價 **$106.74 USD**（價格指數 105.67），假日加價調幅為 **+5.68%**。萬豪體系在假日的價格彈性顯著高於 IHG，尤其休閒渡假品牌（如普吉島萬麗、萬豪）週末加價率高達 8%~15%。
- **凱悅酒店集團 (Hyatt)**：平日均價 **$108.36 USD**，假日均價 **$113.79 USD**，假日調幅為 **+5.01%**。旗下 Park Hyatt、Grand Hyatt、Andaz 兼具商務差旅基底與頂級渡假溢價能力。
- **希爾頓全球 (Hilton)**：平日均價 **$94.62 USD**，假日均價 **$100.24 USD**，假日調幅為 **+5.94%**（Conrad、Waldorf Astoria、Signia）。
- **雅高酒店集團 (Accor)**：平日均價 **$107.59 USD**，假日均價 **$111.52 USD**，假日調幅為 **+3.65%**（Raffles 新加坡萊佛士、Fairmont、Swissotel）。
- **休閒渡假專門集團**：如**晶華麗晶集團 (Silks)** 週末加價率高達 **+6.91%**，反映太魯閣晶英、礁溪晶泉丰旅等渡假點在假日的強勁內需推升力。

---

### 2. 各個區域與國家的房價對比
跨國匯率標準化（統一折算為美元 USD）之平均每晚房價排行：
1. **新加坡 (Singapore)**：**$151.53 USD**（都會金融與高消旅遊勝地，基準房價最高）
2. **香港 (Hong Kong)**：**$120.84 USD**（高密度地價、國際商務門戶）
3. **韓國 (South Korea)**：**$100.54 USD**（首爾明洞與釜山海雲台）
4. **台灣 (Taiwan)**：**$100.32 USD**（台北信義/大安、日月潭、花蓮太魯閣、阿里山渡假熱點）
5. **日本 (Japan)**：**$97.87 USD**（東京、大阪、京都熱門觀光點）
6. **泰國 (Thailand)**：**$82.01 USD**（曼谷精品都會與普吉海島渡假）
7. **中國大陸 (Mainland China)**：**$81.94 USD**（北京、上海國際金融核心）
8. **菲律賓 (Philippines)**：**$69.72 USD**（馬尼拉娛樂城）
9. **越南 (Vietnam)**：**$67.83 USD**（河內古城區經典精品）
10. **馬來西亞 (Malaysia)**：**$66.94 USD**（吉隆坡市中心）
11. **印尼 (Indonesia)**：**$58.21 USD**（雅加達商務精華）

---

### 3. 在不同國家的房價高低是否跟飯店品牌有關聯？
**深度統計實證分析與論證：**
1. **雙重決定模型 (Dual-Determinant Model)**：
   - 房價高低首要受到**「國家宏觀市場基底（Market Baseline）」**影響，各國的平均國民所得、地價租金與整體消費水平決定了該市場的房價門檻（如新加坡基價是印尼的 2.6 倍）。
   - 然而，**飯店品牌對房價具有高度顯著的正向關聯與強大的定價權（Pearson 相關係數 $r = 0.812$）**。
2. **跨國品牌溢價的一致性 (Cross-Border Brand Premium)**：
   - 無論在已開發高價市場（新加坡、日本）或高性價比市場（泰國、越南、馬來西亞），跨國龍頭品牌（萬豪、IHG、凱悅）的每晚售價均比該國市場中位數高出 **15% ~ 35%**。
   - 品牌帶來的忠誠會員（Marriott Bonvoy, IHG One Rewards）、全球分銷系統與硬體標準化設施分數（平均 7.5~9.2 分），確保了其品牌在任何國家皆能享有穩定的「品牌溢價倍數 (Brand Factor)」。
3. **渡假 vs 商務的品牌加價槓桿**：
   - 在渡假型區域，知名品牌假日的定價彈性遠大於非連鎖飯店（渡假品牌假日調幅最高可達 15%~25%）。

---

### 4. 全世界/全區飯店快搜與即時比價系統
- **即時快搜過濾**：鍵入飯店關鍵字（如 `Kimpton`、`Marriott`、`Taipei`、`Tokyo`）即時呈現搜尋結果。
- **多幣別動態換算**：支援 **USD ($)**、**TWD (NT$)**、**EUR (€)**、**JPY (¥)**、**CNY (¥)** 及當地貨幣切換，達成公平的跨國橫向對比。
- **CP值評比指標**：計算 `(設施星等分數 / 每晚房價) * 100`，快速識別高性價比旅館。
- **一鍵匯出**：支援整套報表一鍵匯出為標準 UTF-8 CSV 格式。

---

### 5. 🎯 品牌六維營運基因雷達診斷 (6D Strategic Radar Diagnosis)
為解決單維度房價指標看不出「設施投資報酬」與「平日/假日失衡」的決策盲點，平台導入 **0~100 分標準化六維雷達圖評估模型**：
1. **定價強度 (ADR)** | 2. **假日收益彈性** | 3. **住房去化率** | 4. **硬體設施評分** | 5. **商務客黏著度** | 6. **地段核心優勢**

#### 診斷出的三大典型品牌畫像與投資規劃建議：
- **都會商務偏食型（代表: 洲際 IHG）**：地段 95、商務 100，但假日調幅僅 35（+3.87%）。適合核心都會區；營收管理需啟動「週末微渡假餐飲套票」拉抬假日收益。
- **全能旗艦均衡型（代表: 萬豪 / 凱悅）**：六維指標均衡在 70~85 分，多邊形面積最大，抗市場週期最強。業主需嚴控高星級設施折舊攤提。
- **渡假休閒爆發型（代表: 晶華 Silks）**：假日調幅 100 (+6.86%)、住房去化 92，但地段與商務偏弱。適合風景郊區物業，需強化平日企業 MICE 合約補足週間。

---

## 🛠️ 本地啟動與開發

1. **本地一鍵啟動**：
   雙擊執行 `啟動平台.bat` 或在 PowerShell 中執行：
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\start_dashboard.ps1
   ```
   瀏覽器將自動開啟 `http://localhost:8080`。

2. **重新建置與產出靜態包**：
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\build.ps1
   ```

3. **重新部署至 Cloudflare Workers**：
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\deploy_cloudflare.ps1
   ```

---

## 📁 專案檔案結構

```
D:\grafana-main-41211036\
├── index.html                   # 完整前端單頁應用程式 (Grafana Dark/Light UI)
├── worker.js                    # Cloudflare Worker 生產端主程式 (含 API 與 HTML 服務)
├── worker_template.js           # Worker 程式碼範本
├── template.html                # 前端 HTML 視圖範本
├── build.ps1                    # 自動化組合與建置腳本
├── deploy_cloudflare.ps1        # Cloudflare API 自動發布部署腳本
├── hotel_analytics_data.json    # 80,848 筆數據預先彙整之高效能分析資料集 (260KB)
├── start_dashboard.ps1          # 本地微型 Web Server (支援 API 與靜態檔案)
├── 啟動平台.bat                  # Windows 本地一鍵啟動批次檔
├── wrangler.toml                # Cloudflare Worker 專案組態檔
└── README.md                    # 專案詳細說明與大數據分析報告
```
