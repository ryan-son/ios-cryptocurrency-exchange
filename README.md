# 프로젝트 소개

[Bithumb Public API](https://apidocs.bithumb.com/docs/api_info)를 통해 가상화폐 정보를 제공하는 애플리케이션을 제작합니다.

- 메인 화면을 통해 전체 코인 목록을 확인할 수 있습니다.
- 코인 목록에서 관심, 인기 코인 목록을 확인할 수 있습니다.
- 메인 화면의 코인 목록에서는 현재가와 변동률 정보를 제공합니다.
- 목록에서 코인을 선택하면 일 단위 가격 변동 내역과 실시간 가격 변화를 캔들스틱 차트를 통해 표시합니다.
- 호가정보창을 통해 실시간 매수/매도 내역을 제공합니다.
- 체결정보창을 통해 실시간 체결 내역을 제공합니다.

# Tools

## 개발환경 및 타겟 OS

- Swift 5.5
- Xcode 13.2.1
- iOS 14.0

iOS 사용자의 98%가 iOS 14.0 이상 버전을 사용하고 있으므로 타겟 버전을 iOS 14.0으로 설정하였습니다.

[![](https://i.imgur.com/LV199wv.png)](https://developer.apple.com/kr/support/app-store/)

## 기술

본 프로젝트에서는 TCA를 이용한 이벤트 처리, SwiftUI를 이용한 UI 구성 및 내비게이션 처리, Combine을 이용한 반응형 프로그래밍에 집중하기 위해 아래와 같은 라이브러리를 활용하였습니다.

| 구분 | 기술 | 버전 |
| -- | -- | -- |
| UI / Reactive Programming | [SwiftUI](https://developer.apple.com/documentation/swiftui/) / [Combine                   ](https://developer.apple.com/documentation/combine)                         |        |
| 아키텍처 프레임워크       | [The Composable Architecture (TCA)](https://github.com/pointfreeco/swift-composable-architecture) | 0.33.1 |
| 네트워크 (REST)           | [Moya](https://github.com/Moya/Moya)                         | 15.0.0 |
| 네트워크 (WebSocket)      | [Starscream](https://github.com/daltoniam/Starscream)        | 4.0.4  |
| 차트                      | [Charts](https://github.com/danielgindi/Charts)              | 3.6.0  |
| Image Fetching / Caching  | [KingFisher](https://github.com/onevcat/Kingfisher)          | 7.2.0  |

### 왜 이 기술들에 집중하고자 했나요?

`TCA`는 사용자와의 상호작용, 데이터 변화와 같은 이벤트를 단방향으로 처리하는 `Redux` 패턴의 구현체이며, `SwiftUI`, `Combine`, `UIKit`, `RxSwift` 등의 기술을 범용적으로 적용하여 사용할 수 있기에 기존에 `RxSwift`, `RxCocoa`와 함께 사용되던 `ReactorKit`을 대체하는 기술로 인식되고 있습니다. 따라서 향후 프로덕트 개발에 SwiftUI와 Combine을 활용하는 시점이 다가올수록 커뮤니티가 더욱 강력해질 것이고, 활용 규모가 더욱 넓어질 것이라 판단하였습니다.

`SwiftUI`는 현재 웹 프론트엔드의 `React`, 안드로이드의 `JetPack Compose`와 같이 선언형으로 UI를 작성하는 방식으로, Apple에서 제공하는 UI 개발 프레임워크이므로 향후 UIKit과 병행하여 사용하거나, 대체할 기술로 인식되고 있습니다.

`Combine`도 `SwiftUI`와 마찬가지로 Apple이 제공하는 First party 프레임워크이며, 기존에 사용되던 `RxSwift`, `ReactiveSwift`와 같은 third party 라이브러리를 대체할 기술로 인식되고 있습니다.

# 주요기능 미리보기

| 코인 목록 | 현재가 및 차트 |
| - | - |
| <img src="https://i.imgur.com/MLpIl1R.gif" alt="coin-list" width="375"/> | <img src="https://i.imgur.com/5Ocd4gL.gif" alt="chart" width="375"/> |

| 체결정보 | 호가정보 |
| - | - |
| <img src="https://i.imgur.com/vK3TPNA.gif" alt="transaction" width="375"/> | <img src="https://i.imgur.com/rHHENLj.gif" alt="order-book" width="375"/> |

# 애플리케이션 구조

`Clean architecture`에 착안하여 `Data source`, `Repository`, `Domain`, `Presentation` Layer로 나누었습니다. 각 레이어의 역할은 아래와 같습니다.

| 구분 | 역할 |
| --- | --- |
| Data source  | 네트워크와 로컬 DB에서의 데이터 제공을 담당합니다.           |
| Repository   | Data source에서 제공한 데이터를 Domain 레이어와 이어주는 역할을 수행합니다. 이 과정에서 데이터의 출처를 추상화합니다. |
| Domain       | 앱의 핵심 비즈니스 로직을 수행합니다. 목적 사용 케이스에 따라 비즈니스 로직이 분리되어 있습니다. 이 과정에서 Repository를 통해 전달받은 데이터를 앱이 제공하는 핵심 비즈니스 로직에서 활용하는 엔티티 형태로 변환합니다. |
| Presentation | Domain 레이어에서 목적에 맞게 가공된 데이터를 제공받아 화면에 표시하는 역할을 수행합니다. 화면에 최종적으로 보여줄 내용을 가공하기 위해 상태와 액션, 의존하는 환경을 정의하여 사용하며, 사용자와의 상호작용, 데이터 변화 등의 이벤트를 단방향의 Redux 패턴으로 수행합니다. |

<img src="https://user-images.githubusercontent.com/69730931/158045051-b2ef173b-27ad-431a-a30e-9cecbbb6fc01.png" alt="chart" width="375"/>

## 이렇게 구조를 구성한 이유는 무엇인가요?

각 레이어를 역할에 따라 분리하여 타입의 인터페이스(수신한 내용과 전달할 내용)에 집중할 수 있는 환경을 조성함으로써 프로토콜 주도 개발이 가능하여 각 모듈의 개발자가 본인 담당하는 부분에 집중할 수 있도록 만들 수 있기 때문입니다.

# 화면 구현 상세

## 공통

### 구조
- `DataSources`에서 `WebSocket`, `REST`, `Persistence` 서비스에서 `ResponseDTO`를 통해 데이터를 가져오는 부분이 정의되어 있습니다.
- `Repositories`에서 `DataSources`로 부터 받아오는 데이터를, 어디서 부터 온 데이터인지 알지 못하도록 추상화 합니다.
- `Domains`에서 `Repositories`로 부터 받아오는 데이터를, 앱에서 사용 할 `Entities`로 변경하는 작업과 수행하는 역활을 기준으로 `UseCases`를 분리 합니다.
- `Presentations`에서 `UseCases`에서 부터 받아오는 데이터를 이용해 비지니스 로직을 태운 `State`를 생성하며 이는 비지니스 로직에 활용 될 수 있습니다.
- `State`를 최종적으로 화면에 표시 할 `ViewState`로 전환하여 `View`에 전달 하여 화면을 그립니다.

### 개선할 수 있는 점
- 현재는 뷰 생성시 단순히 `Store`를 생성하여 뷰를 만들고 있지만, `pullback`을 사용하여 화면을 구조화하는 개선이 필요합니다.
- `onAppear` 시점에 데이터를 가져오는 경우 화면에 표시되지 않는 문제점이 있어 `init` 시점에 가져오고 있는데 개선이 필요합니다.

## 코인 목록 화면

### 기능
- 코인별로 실시간 현재가, 변동률 정보를 표시합니다.
- 코인 관심 목록을 등록 할 수 있습니다.

### 구조
- `TickerUseCase`로 부터 받은 `Single(REST) - Tickers(ALL_KRW)` 데이터로 `Stream(WebSocket) - Ticker`를 요청하고, 두가지 데이터에 `Like` 데이터를 추가하여 실시간 현재가, 변동률 정보, 관심 여부를 화면에 표시 합니다.
- `TickerUseCase`를 통해 코인의 관심 여부를 등록합니다. 
- `TickerUseCase`는 내부적으로 `BithumbRepository`를 통해 `CoreDataStorage` 영역인 `CoinIsLikeStorage`에 해당 코인이 관심 코인으로 등록되어 있는지를 확인하거나 관심 코인에 등록합니다.

## 현재가 및 차트 화면

### 기능
- 실시간 현재가, 변동률, 변동금액을 표시합니다.
- 일 단위 실시간 차트를 제공 합니다.
- 차트를 스크롤 하거나, 확대 축소 가능 합니다.

### 구조
- 현재가를 표시하는 `CoinCurrentTickerView`와 차트를 표시하는 `CoinCandleChartView`로 구성되어 있습니다.
- 코인 목록 화면에서 풀백받은 상태를 전달 받아 현재가 화면과 차트 화면으로 전달합니다.
- 현재가 화면과 차트 화면은 전달 받은 상태를 토대로 `CandleChartUseCase`, `TickerUseCase`를 통해 티커와 캔들스틱 정보를 요청합니다.
- HTTP 형식으로 요청한 응답이 돌아오면 `WebSocket` 연결을 시도하며 연결 성공 시 실시간 현재가를 변경하고 차트에 현재가를 추가하여 캔들 스틱을 그립니다. 

## 체결 정보 화면

### 기능
- 해당 코인의 실시간 체결 현황을 목록 형식으로 표시합니다.

### 구조
- 현재가 및 차트 화면에서 받은 `symbol`을 기반으로 `UseCase`로 부터 받은 `Single(REST)` `Transcation History` 데이터에 `Stream(WebSocket)` `Transaction` 데이터를 조합하여 화면에 표시합니다.

## 호가 정보 화면

### 기능
- 해당 코인의 실시간 호가 현황을 목록 형식으로 표시합니다.
- 매수, 매도 각각 10 호가까지 표현합니다.
- 페이지에 존재하는 호가 중 가장 수량이 많은 것을 100% 비율로 하여 각 호가에 주문된 물량을 막대 형식으로 표현합니다.
- 화면이 표시되면 스크롤이 매수, 매도 중앙에 위치합니다.


### 구조
- 코인의 실시간 현재가와 아이콘을 표시하는 `CoinPriceView`와 실시간 호가 정보를 표시하는 `OrderBookListView`로 구성되어 있습니다.
- 화면이 나타날 때 HTTP 통신을 통해 현재 등록된 전체 호가 정보와 호가 정보 WebSocket 정보를 요청하며 이를 조합하여 화면에 표시합니다.
- 호가 정보 HTTP 요청의 응답을 수신하면 각 호가별로 주문된 최대 물량을 기준으로 각 호가의 물량의 비율을 구하고, 가격을 기준으로 정렬하여 상태에 기록합니다.
- Ticker 정보 WebSocket 응답을 수신할 때마다 WebSocket 응답에 포함된 현재가를 기준으로 매수, 매도 영역을 구분하여 호가 위치를 조정하여 화면에 표시합니다.
- `ScrollViewReader`의 `proxy`를 이용하여 화면 진입시 매수와 매도 정보를 모두 확인할 수 있도록 화면의 중앙에 위치하도록 만듭니다.

# 팀 구성
## TopKim
- [GitHub](https://github.com/topkim993)

## TodaysSky
- [GitHub](https://github.com/todayssky)
- [Blog](https://todayssky.tistory.com)

## Ryan Son
- [GitHub](https://github.com/ryan-son)
- [Blog](https://velog.io/@ryan-son)
