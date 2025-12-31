
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tetete/widgets/header_image.dart';
import '../dialogs/cart_dialogs.dart';
import '../dto/ArticleDTO.dart';
import '../dto/CategoryDTO.dart';
import '../repositories/demo_catalog_loader.dart';
import '../utils/article_clone.dart';
import '../utils/cart_utils.dart';
import '../utils/money_utils.dart';
import '../widgets/catalog/catalog_view.dart';
import '../widgets/cart/cart_view.dart';
import '../widgets/order/order_summary_bar.dart';
import '../widgets/payment/pay_view.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {

  final List<CategoryDTO> _categorylist = [];
  final List<ArticleDTO> articleDTOList = [];
  final List<ArticleDTO> warenkorb = [];

  int _currentSelectedIndex = 0;
  ArticleDTO? selectedArticle;

  bool showArticleExtras = false;
  bool showWarenkorb = false;
  bool showBezahlen = false;
  bool bezahlungFertig = false;

  late AnimationController animationcontroller;
  double progress = 1.0;

  bool loadedData = false;

  @override
  void initState() {
    super.initState();

    animationcontroller = AnimationController(
      value: 1.0,
      vsync: this,
      duration: const Duration(seconds: 6),
    );

    animationcontroller.addListener(() {
      if (animationcontroller.isAnimating) {
        setState(() {
          progress = animationcontroller.value;
          if (countText == '0') {
            bezahlungFertig = true;
          }
        });
      }
    });

    _loadDemo().whenComplete(() {
      setState(() => loadedData = true);
    });
  }

  Future<void> _loadDemo() async {
    final data = await DemoCatalogLoader().load();
    _categorylist
      ..clear()
      ..addAll(data.categories);
    articleDTOList
      ..clear()
      ..addAll(data.articles);
  }

  @override
  void dispose() {
    animationcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if (!loadedData) {
      return SafeArea(
        child: Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: LoadingAnimationWidget.progressiveDots(
              color: const Color(0xFF7B1A33),
              size: 100,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [

            // Header image
            const HeaderImage(assetPath: "lib/images/startimage.jpg"),

            // Main area
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                color: Colors.white,
                child: showBezahlen
                    ? PayView(
                  paymentDone: bezahlungFertig,
                  progress: progress,
                  controller: animationcontroller,
                  countText: countText,
                  onOk: _resetAfterPay,
                )
                    : showWarenkorb
                    ? CartView(
                  cart: warenkorb,
                  onChanged: _redraw,
                  onConfirmRemoveArticle: _confirmRemoveCartItem,
                  onConfirmRemoveExtra: _confirmRemoveExtra,
                )
                    : CatalogView(
                  categories: _categorylist,
                  selectedCategoryIndex: _currentSelectedIndex,
                  articlesForCategory: articlesForSelectedCategory,
                  showArticleExtras: showArticleExtras,
                  selectedArticle: selectedArticle,
                  onSelectCategory: _selectCategory,
                  onSelectArticle: _selectArticle,
                  onBackFromExtras: _backFromExtras,
                  onAddSelectedToCart: _addSelectedToCart,
                  onExtrasChanged: _redraw,
                ),
              ),
            ),

            // Footer
            OrderSummaryBar(
              showBezahlen: showBezahlen,
              showWarenkorb: showWarenkorb,
              cartNotEmpty: warenkorb.isNotEmpty,
              itemCount: CartUtils.itemCount(warenkorb),
              totalText: totalText,
              onBackFromCart: () => setState(() => showWarenkorb = false),
              onPay: _startPay,
              onCancelCart: _confirmClearCart,
              onShowCart: () => setState(() => showWarenkorb = true),
            ),

          ],
        ),
      ),
    );
  }

  List<ArticleDTO> get articlesForSelectedCategory {
    if (_categorylist.isEmpty) return [];
    final name = _categorylist[_currentSelectedIndex].name;
    if (name == null) return [];

    final list = <ArticleDTO>[];
    for (final a in articleDTOList) {
      if (a.group?.name == name) list.add(a);
    }
    return list;
  }

  String get countText {
    final count = animationcontroller.duration! * animationcontroller.value;
    return count.inSeconds.toString();
  }

  String get totalText {
    final total = MoneyUtils.roundDouble(CartUtils.totalPrice(warenkorb), 2);
    return MoneyUtils.formatCurrency(total);
  }

  // ----------------------------
  // Actions / State transitions
  // ----------------------------
  void _redraw() => setState(() {});

  void _selectCategory(int index) {
    setState(() {
      _currentSelectedIndex = index;
      selectedArticle = null;
      showArticleExtras = false;
    });
  }

  void _selectArticle(ArticleDTO article) {
    setState(() {
      selectedArticle = ArticleClone.cloneForSelection(article);
      showArticleExtras = true;
    });
  }

  void _backFromExtras() {
    setState(() {
      selectedArticle = null;
      showArticleExtras = false;
    });
  }

  void _addSelectedToCart() {
    if (selectedArticle == null) return;
    final toCart = ArticleClone.cloneForCartFromSelected(selectedArticle!);

    setState(() {
      warenkorb.add(toCart);
      selectedArticle = null;
      showArticleExtras = false;
    });
  }

  void _startPay() {
    if (warenkorb.isEmpty) return;

    setState(() {
      showBezahlen = true;
      bezahlungFertig = false;
      animationcontroller.value = 1.0;
      animationcontroller.reverse(from: 1.0);
    });
  }

  void _resetAfterPay() {
    setState(() {
      bezahlungFertig = false;
      showBezahlen = false;
      showWarenkorb = false;
      showArticleExtras = false;
      warenkorb.clear();
      _currentSelectedIndex = 0;
      selectedArticle = null;
    });
  }

  // ----------------------------
  // Dialogs (weiter in MainPage)
  // ----------------------------
  Future<void> _confirmClearCart() async {
    if (warenkorb.isEmpty) return;

    final ok = await CartDialogs.confirmClearCart(context);
    if (!ok) return;

    setState(() {
      warenkorb.clear();
    });
  }

  Future<void> _confirmRemoveCartItem(int index) async {
    final ok = await CartDialogs.confirmRemoveArticle(context);
    if (!ok) return;

    setState(() {
      warenkorb.removeAt(index);
      if (warenkorb.isEmpty) showWarenkorb = false;
    });
  }

  Future<void> _confirmRemoveExtra(int cartIndex, int extraIndex) async {
    final ok = await CartDialogs.confirmRemoveExtra(context);
    if (!ok) return;

    setState(() {
      warenkorb[cartIndex].extraslist!.removeAt(extraIndex);
    });
  }

}
