import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import '../core/constants/app_colors.dart';
import '../core/widgets/UncoverButton.dart';
import '../helper_components/componenets/trading_dialog.dart';
import '../helper_components/local_storage/AppPreferences.dart';
import '../models_class/quiz/QuizQuestion.dart';
import '../routes/app_routes.dart';
import 'FullScreenVideoPlayer.dart';



class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _marqueeController = ScrollController();
  bool _isInitialized = false;
  late VideoPlayerController _videoController;
  bool _isVideoInitialized = false;

  // Chat state (Ask tab)
  final TextEditingController _chatInput = TextEditingController();
  final ScrollController _chatScroll = ScrollController();
  final List<_ChatMsg> _chatMessages = [
    _ChatMsg('Hello! How can I help you today?', false, '9:00 AM'),
    _ChatMsg('What is the Nifty trend for this week?', true, '9:01 AM'),
    _ChatMsg('Based on current technicals, Nifty shows bullish momentum above 22,200. Key resistance at 22,600. Keep a stop-loss at 22,100 for intraday.', false, '9:01 AM'),
    _ChatMsg('Which index option should I buy?', true, '9:03 AM'),
    _ChatMsg('Consider Nifty 22,500 CE for a bullish view with a target of 200–250 points. Risk only what you can afford to lose.', false, '9:03 AM'),
  ];

  // Live ticker state
  Timer? _tickerTimer;
  final _rng = Random();
  double _niftyPrice      = 22456.80;
  double _niftyChange     = 128.45;
  double _niftyPct        = 0.57;
  double _bankNiftyPrice  = 47892.30;
  double _bankNiftyChange = -234.60;
  double _bankNiftyPct    = -0.49;

  // Nifty OHLC detail — Open/PrevClose fixed for the day; High/Low update live
  final double _niftyOpen      = 22328.35;
  final double _niftyPrevClose = 22328.35;
  double _niftyHigh            = 22512.60;
  double _niftyLow             = 22298.15;
  final double _nifty52wHigh   = 24198.85;
  final double _nifty52wLow    = 18837.85;
  int    _niftyVolume          = 142836500;  // shares, updates every few ticks
  bool   _niftyExpanded        = false;

  @override
  void initState() {
    super.initState();
    _startMarquee();
    _initVideo();
    _startLiveTicker();
  }
  @override
  void dispose() {
    _marqueeController.dispose();
    _videoController.dispose();
    _tickerTimer?.cancel();
    _chatInput.dispose();
    _chatScroll.dispose();
    super.dispose();
  }

  void _startLiveTicker() {
    _tickerTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        final nd = (_rng.nextDouble() - 0.48) * 7.5;
        final bd = (_rng.nextDouble() - 0.48) * 14.0;
        _niftyPrice      += nd;
        _bankNiftyPrice  += bd;
        _niftyChange     += nd;
        _bankNiftyChange += bd;
        _niftyPct        = (_niftyChange / (_niftyPrice - _niftyChange)) * 100;
        _bankNiftyPct    = (_bankNiftyChange / (_bankNiftyPrice - _bankNiftyChange)) * 100;
        // Update intraday High / Low
        if (_niftyPrice > _niftyHigh) _niftyHigh = _niftyPrice;
        if (_niftyPrice < _niftyLow)  _niftyLow  = _niftyPrice;
        // Volume ticks up randomly every ~3 sec
        if (_rng.nextInt(3) == 0) _niftyVolume += _rng.nextInt(120000) + 30000;
      });
    });
  }
  void _initVideo() async {
    _videoController = VideoPlayerController.networkUrl(
     Uri.parse("https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")
    );

    await _videoController.initialize();
    setState(() => _isInitialized = true);
    _videoController
      ..setLooping(true)
      ..play();

    setState(() {
      _isVideoInitialized = true;
    });
  }


  void _startMarquee() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.doWhile(() async {
        if (!mounted || !_marqueeController.hasClients) return false;

        await _marqueeController.animateTo(
          _marqueeController.position.maxScrollExtent,
          duration: const Duration(seconds: 15),
          curve: Curves.linear,
        );

        if (!mounted || !_marqueeController.hasClients) return false;
        _marqueeController.jumpTo(0);
        return true;
      });
    });
  }
  // final List<QuizQuestion> quizQuestions = [
  //   QuizQuestion(
  //     question: "What is NIFTY?",
  //     options: ["Index", "Stock"],
  //   ),
  //   QuizQuestion(
  //     question: "Market opens at?",
  //     options: ["9:00 AM", "9:15 AM", "9:30 AM", "10:00 AM"],
  //   ),
  //   QuizQuestion(
  //     question: "Which are derivatives?",
  //     options: ["Futures", "Options", "Equity", "Commodity", "Forex", "Crypto"],
  //   ),
  // ];

  final List<QuizQuestion> quizQuestions = [
    QuizQuestion(
      question: "What is NIFTY?",
      options: ["Index", "Stock"],
    ),
    QuizQuestion(
      question: "Market opens at?",
      options: ["9:00 AM", "9:15 AM", "9:30 AM", "10:00 AM"],
    ),
    QuizQuestion(
      question: "Which are derivatives?",
      options: ["Futures", "Options", "Equity", "Commodity", "Forex", "Crypto"],
    ),

    // ✅ Newly added questions
    QuizQuestion(
      question: "What does NSE stand for?",
      options: [
        "National Stock Exchange",
        "New Stock Exchange",
        "National Share Exchange",
        "New Share Exchange"
      ],
    ),
    QuizQuestion(
      question: "What is Sensex?",
      options: [
        "Index of BSE",
        "Index of NSE",
        "A Stock",
        "A Mutual Fund"
      ],
    ),
    QuizQuestion(
      question: "Which segment is used for intraday trading?",
      options: ["Cash Market", "F&O", "Commodity", "Currency"],
    ),
    QuizQuestion(
      question: "What is a Bull Market?",
      options: [
        "Rising Market",
        "Falling Market",
        "Sideways Market",
        "Closed Market"
      ],
    ),
    QuizQuestion(
      question: "What is a Bear Market?",
      options: [
        "Falling Market",
        "Rising Market",
        "High Volume Market",
        "Stable Market"
      ],
    ),
    QuizQuestion(
      question: "Lot size is applicable in?",
      options: [
        "Futures & Options",
        "Equity Delivery",
        "IPO",
        "Mutual Funds"
      ],
    ),
    QuizQuestion(
      question: "Which order executes immediately at market price?",
      options: [
        "Market Order",
        "Limit Order",
        "Stop Loss Order",
        "GTT Order"
      ],
    ),

  ];





  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey, // ✅ add key
      drawer: _appDrawer(), // ✅ add drawer
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                _topBar(size),
                _videoSection(size),
                _tipsMarquee(size),
                _tabBar(),
                Expanded(child: _scrollableBody()),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _videoSection(Size size) {
    return Container(
      height: size.height * 0.35,
      width: double.infinity,
      color: Colors.black,
      child: _isInitialized
          ? Stack(
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: _videoController.value.aspectRatio,
              child: VideoPlayer(_videoController),
            ),
          ),

          /// PLAY / PAUSE
          Center(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _videoController.value.isPlaying
                      ? _videoController.pause()
                      : _videoController.play();
                });
              },
              child: Icon(
                _videoController.value.isPlaying
                    ? Icons.pause_circle
                    : Icons.play_circle,
                color: Colors.white,
                size: 80,
              ),
            ),
          ),

          /// FULLSCREEN ICON
          Positioned(
            bottom: 10,
            right: 10,
            child: IconButton(
              icon: const Icon(
                Icons.fullscreen,
                color: Colors.white,
                size: 28,
              ),
              onPressed: () {
                _openFullScreen(context);
              },
            ),
          ),
        ],
      )
          : const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }

  void _openFullScreen(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FullScreenVideoPlayer(controller: _videoController),
      ),
    );

    /// Restore UI when back
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }



  Widget _appDrawer() {
    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 160,
              decoration: BoxDecoration(
                color: AppColors.primaryRed,
              ),
              padding: EdgeInsets.only(left: 20,top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 32),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Welcome",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Say Mira Dashboard",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            _drawerItem(Icons.dashboard, "Dashboard",
                onTap: () {


                }),
            _drawerItem(Icons.dashboard, "Quiz",
                onTap: () {
                  showQuizDialog1(context);
                  // TradingDialog.show(
                  //   context: context,
                  //   title: "Unlock Trading Tips",
                  //   message: "Answer a quick quiz to unlock premium tips.",
                  //   type: TradingDialogType.error,
                  //   showPrimary: true,
                  //   showSecondary: true,
                  //   primaryText: "UNLOCK",
                  //   secondaryText: "PASS",
                  //   onPrimary: () {
                  //   //  Navigator.pop(context); // close unlock dialog
                  //     showQuizDialog(context);
                  //   },
                  //   onSecondary: () {
                  //     Navigator.pop(context); // just close
                  //   },
                  // );

                }),
            _drawerItem(Icons.person_2_outlined, "Profile",
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.profile);
                }),
            _drawerItem(Icons.add_alert_outlined, "Alert",
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.alert);
                }),
            _drawerItem(Icons.campaign_outlined, "Commentary",
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.commentary);
                }),
            _drawerItem(Icons.redeem_outlined, "Referral",
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.referral);
                }),
            _drawerItem(Icons.account_balance_wallet_outlined, "Wallet",
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.wallet);
                }),
            _drawerItem(Icons.logout, "Logout",
                onTap: () {
                  TradingDialog.show(
                    context: context,
                    title: "Logout",
                    message: "Are you sure you want to logout?",
                    type: TradingDialogType.error,
                    showPrimary: true,
                    showSecondary: true,
                    primaryText: "YES",
                    secondaryText: "CANCEL",

                    onPrimary: () async {

                      /// CLOSE DIALOG FIRST
                      Navigator.pop(context);

                      /// ✅ CLEAR COMMON SHARED PREF
                      await AppPreferences.clear();

                      /// ✅ REDIRECT TO LOGIN (CLEAR STACK)
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.login, // avoid hardcoded string
                            (route) => false,
                      );
                    },

                    onSecondary: () {
                      Navigator.pop(context); // just close dialog
                    },
                  );
                }
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(
      IconData icon,
      String title, {
        required VoidCallback onTap,
      }) {
    return ListTile(
      leading: Icon(icon, color: Colors.red),
      title: Text(title),
      onTap: () {
        Navigator.pop(context); // close drawer
        onTap(); // 👈 individual action
      },
    );
  }

  void showQuizDialog1(BuildContext context) {
    int currentIndex = 0;
    int elapsedSeconds = 0;


    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (dialogContext) {



        return StatefulBuilder(
          builder: (context, setState) {
            final question = quizQuestions[currentIndex];

            return Material(
              type: MaterialType.transparency,
              child: Center(
                child: Stack(
                  clipBehavior: Clip.none, // ⭐ REQUIRED

                  children: [

                    /// ================= MAIN CARD =================
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 18),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 25,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          /// ================= HEADER =================
                          Container(
                            height:MediaQuery.of(context).size.height*0.15,
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xff8e0000),
                                  Color(0xffd32f2f),
                                ],
                              ),
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(24),
                              ),
                            ),
                            child: Row(
                              children: [

                                /// QUIZ NO
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    "Q no. ${currentIndex + 1}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 12),

                                /// QUIZ NAME (CENTER)
                                 Expanded(
                                  child: Image.asset("assets/images/treadjockylogo2.png",
                                    ),

                                   // Column(
                                  //   children: [
                                  //
                                  //     Text(
                                  //       "",
                                  //       textAlign: TextAlign.center,
                                  //       maxLines: 1,
                                  //       overflow: TextOverflow.ellipsis,
                                  //       style: TextStyle(
                                  //         color: Colors.white,
                                  //         fontSize: 22,
                                  //         fontWeight: FontWeight.w700,
                                  //       ),
                                  //     ),
                                  //
                                  //     // Text(
                                  //     //   "Tread Jocky",
                                  //     //   textAlign: TextAlign.center,
                                  //     //   maxLines: 1,
                                  //     //   overflow: TextOverflow.ellipsis,
                                  //     //   style: TextStyle(
                                  //     //     color: Colors.white,
                                  //     //     fontSize: 17,
                                  //     //     fontWeight: FontWeight.w700,
                                  //     //   ),
                                  //     // ),
                                  //   ],
                                  // ),
                                ),

                                /// TIMER
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.25),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    "00:00:00",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          /// ================= BODY =================
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 26, 20, 24),
                            child: Column(
                              children: [

                                /// QUESTION TEXT
                                // Text(
                                //   "Answer a quick quiz to unlock premium",
                                //   textAlign: TextAlign.center,
                                //   style: const TextStyle(
                                //     fontSize: 18,
                                //     fontWeight: FontWeight.w700,
                                //     height: 1.4,
                                //   ),
                                // ),

                                const SizedBox(height: 0),

                                /// CENTER CTA BUTTON (UNCOVER / CONTINUE)
                                SizedBox(
                                  width: MediaQuery.of(context).size.width*0.9,
                                  height: MediaQuery.of(context).size.height*0.15,
                                  child: GestureDetector(
                                    child: Image.asset("assets/images/uncoverbutton.png"),
                                    onTap: () {
                                      print("Uncover pressed");
                                      Navigator.of(context).pop();
                                      showQuizDialog(context);
                                    },
                                  )
                                  // ElevatedButton(
                                  //   style: ElevatedButton.styleFrom(
                                  //     backgroundColor: const Color(0xffd32f2f),
                                  //     shape: RoundedRectangleBorder(
                                  //       borderRadius: BorderRadius.circular(14),
                                  //     ),
                                  //   ),
                                  //   onPressed: () {
                                  //     Navigator.of(context).pop();
                                  //     showQuizDialog(context);
                                  //     // if (currentIndex <
                                  //     //     quizQuestions.length - 1) {
                                  //     //   setState(() {
                                  //     //     currentIndex++;
                                  //     //   });
                                  //     // } else {
                                  //     //   quizTimer?.cancel();
                                  //     //   Navigator.pop(context);
                                  //     //   _quizCompletedDialog(context);
                                  //     // }
                                  //   },
                                  //   child: const Text(
                                  //     "Uncover",
                                  //     style: TextStyle(
                                  //       fontSize: 26,
                                  //       fontWeight: FontWeight.bold,
                                  //       color: Colors.white,
                                  //     ),
                                  //   ),
                                  // ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// ================= CLOSE ICON (HALF OUTSIDE / HALF INSIDE) =================
                    Positioned(
                      top: -12,   // 👈 pushes icon half outside
                      right: 2, // 👈 pushes icon half outside
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(50),
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 36,
                            width: 36,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((_) {
     // quizTimer?.cancel();
    });
  }

  void showQuizDialog(BuildContext context) {
    int currentIndex = 0;
    int elapsedSeconds = 0; // ⏱ count-up timer
    Timer? quizTimer;

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (dialogContext) {

        quizTimer ??= Timer.periodic(
          const Duration(seconds: 1),
              (timer) {
            elapsedSeconds++;
            (dialogContext as Element).markNeedsBuild();
          },
        );

        return StatefulBuilder(
          builder: (context, setState) {
            final question = quizQuestions[currentIndex];
            final progress =
                (currentIndex + 1) / quizQuestions.length;

            return Material(
              type: MaterialType.transparency,
              child: Center(
                child: Stack(
                  clipBehavior: Clip.none, // ⭐ REQUIRED
                  children: [

                    /// ================= MAIN CARD =================
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 18),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xfffdfdfd),
                            Color(0xfff4f4f4),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 30,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          // ================= HEADER =================
                          Container(
                            height:MediaQuery.of(context).size.height*0.16,
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xff8e0000),
                                  Color(0xffd32f2f),
                                ],
                              ),
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(28),
                              ),
                            ),
                            child: Row(
                              children: [
                                /// QUIZ NO
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    "Q no. ${currentIndex + 1}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 12),

                                /// QUIZ NAME (CENTER)
                                Expanded(
                                  child: Image.asset("assets/images/treadjockylogo2.png",
                                  ),

                                  // Column(
                                  //   children: [
                                  //
                                  //     Text(
                                  //       "",
                                  //       textAlign: TextAlign.center,
                                  //       maxLines: 1,
                                  //       overflow: TextOverflow.ellipsis,
                                  //       style: TextStyle(
                                  //         color: Colors.white,
                                  //         fontSize: 22,
                                  //         fontWeight: FontWeight.w700,
                                  //       ),
                                  //     ),
                                  //
                                  //     // Text(
                                  //     //   "Tread Jocky",
                                  //     //   textAlign: TextAlign.center,
                                  //     //   maxLines: 1,
                                  //     //   overflow: TextOverflow.ellipsis,
                                  //     //   style: TextStyle(
                                  //     //     color: Colors.white,
                                  //     //     fontSize: 17,
                                  //     //     fontWeight: FontWeight.w700,
                                  //     //   ),
                                  //     // ),
                                  //   ],
                                  // ),
                                ),

                                /// ⏱ COUNT-UP TIMER (TOP RIGHT)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.25),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    formatElapsedTime(elapsedSeconds),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          LinearProgressIndicator(
                            value: progress,
                            minHeight: 5,
                            backgroundColor: Colors.grey.shade300,
                            color: const Color(0xffd32f2f),
                          ),

                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Text(
                                  "QUESTION ${currentIndex + 1}",
                                  style: TextStyle(
                                    color: Colors.red.shade700,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),

                                const SizedBox(height: 12),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      question.question,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        height: 1.4,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    TextButton.icon(
                                      onPressed: () {
                                        if (currentIndex < quizQuestions.length - 1) {
                                          setState(() {
                                            currentIndex++; // ✅ skip current question
                                          });
                                        } else {
                                          quizTimer?.cancel();
                                          Navigator.pop(context);
                                          _quizCompletedDialog(context);
                                        }
                                      },
                                      icon: const Icon(Icons.skip_next),
                                      label: const Text(
                                        "Pass",
                                        style: TextStyle(fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                ),


                                const SizedBox(height: 20),

                                ...question.options.map(
                                      (opt) => _premiumQuizOption(
                                    text: opt,
                                    onTap: () {
                                      if (currentIndex <
                                          quizQuestions.length - 1) {
                                        setState(() {
                                          currentIndex++;
                                        });
                                      } else {
                                        quizTimer?.cancel();
                                        Navigator.pop(context);
                                        _quizCompletedDialog(context);
                                      }
                                    },
                                  ),
                                ),

                                // Align(
                                //   alignment: Alignment.centerRight,
                                //   child:Row(
                                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //     children: [
                                //
                                //       /// PASS BUTTON (SKIP QUESTION)
                                //
                                //
                                //       /// EXIT QUIZ
                                //       TextButton.icon(
                                //         onPressed: () {
                                //           quizTimer?.cancel();
                                //           Navigator.pop(context);
                                //         },
                                //         icon: const Icon(Icons.close, size: 18),
                                //         label: const Text("Exit Quiz"),
                                //       ),
                                //     ],
                                //   ),
                                //
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    /// ================= CLOSE ICON (HALF OUTSIDE / HALF INSIDE) =================
                    Positioned(
                      top: -12,   // 👈 pushes icon half outside
                      right: 2, // 👈 pushes icon half outside
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(50),
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 36,
                            width: 36,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((_) {
      quizTimer?.cancel(); // safety cleanup
    });
  }


  String formatElapsedTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    if (hours > 0) {
      return "${hours.toString().padLeft(2, '0')}:"
          "${minutes.toString().padLeft(2, '0')}:"
          "${secs.toString().padLeft(2, '0')}";
    } else {
      return "${minutes.toString().padLeft(2, '0')}:"
          "${secs.toString().padLeft(2, '0')}";
    }
  }



  Widget _premiumQuizOption({
    required String text,
    required VoidCallback onTap,
  })
  {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 26,
              width: 26,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red),
              ),
              child: const Icon(
                Icons.check,
                size: 16,
                color: Colors.red,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  void _quizCompletedDialog(BuildContext context) {
    TradingDialog.show(
      context: context,
      title: "Unlocked 🎉",
      message: "You have successfully unlocked premium trading tips!",
      type: TradingDialogType.success,
      showPrimary: true,
      showSecondary: false,
      primaryText: "OK",
      onPrimary: () {
        Navigator.pop(context);
      },
    );
  }

  Widget _quizOption(String text, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }



  // 🔴 Top Bar
  Widget _topBar(var size) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        //    color: AppColors.primaryRed,
        border: Border.all(color: Colors.red.shade800, width: 2),
      ),
      child: Row(
        children: [
          const Icon(Icons.home, color: Colors.red),
          const Spacer(),
          Image.asset(
            'assets/images/logosaymira.png',
            width: size.width * 0.3,
          ),
          // Column(
          //   children: const [
          //     Text(
          //       "Say Mira",
          //       style: TextStyle(
          //           color: Colors.red,
          //           fontWeight: FontWeight.bold,
          //           fontSize: 16),
          //     ),
          //     Text(
          //       "INDEX ↗",
          //       style: TextStyle(
          //           color: Colors.green,
          //           fontWeight: FontWeight.bold,
          //           fontSize: 12),
          //     ),
          //   ],
          // ),
          const Spacer(),
          const Icon(Icons.call, color: Colors.green),
          const SizedBox(width: 12),
          GestureDetector(
              onTap: (){
                _scaffoldKey.currentState?.openDrawer();

              },
              child: Icon(Icons.menu, color: Colors.black)),
        ],
      ),
    );
  }

// ===================== TIPS MARQUEE (10%) =====================

  Widget _tipsMarquee(Size size) {
    return Container(
      height: size.height * 0.05,
      color: Colors.orange.shade100,
      child: ListView(
        controller: _marqueeController,
        scrollDirection: Axis.horizontal,
        children: const [
          _TipItem("Buy Nifty @2400 | SL 2380"),
          _TipItem("BankNifty target 48600"),
          _TipItem("Gold breakout above 71500"),
          _TipItem("Crude oil intraday bullish"),
          _TipItem("Gold breakout above 71500"),
          _TipItem("Crude oil intraday bullish"),
        ],
      ),
    );
  }
  // 📢 Alert Strip
  Widget _alertStrip() {
    return Container(
      width: double.infinity,
      color: Colors.grey.shade300,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: const Text(
        "Buy Nifty Future at 2400, SL",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _tabBar() {
    final tabs = ["Trading Tips", "History", "Ask"];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: List.generate(
          tabs.length,
              (index) => _tabItem(
            title: tabs[index],
            index: index,
          ),
        ),
      ),
    );
  }
  int _selectedTab = 0;

  Widget _tabItem({
    required String title,
    required int index,
  }) {
    final bool active = _selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedTab = index);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: active
                ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ]
                : [],
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: active ? FontWeight.bold : FontWeight.w500,
                color: active ? Colors.red.shade700 : Colors.grey.shade700,
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget _liveTicker() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8E8E8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 7, color: Colors.green),
          const SizedBox(width: 5),
          const Text(
            'LIVE',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.green, letterSpacing: 0.5),
          ),
          const SizedBox(width: 12),
          Expanded(child: _tickerItem('NIFTY 50',   _niftyPrice,     _niftyChange,     _niftyPct)),
          Container(width: 1, height: 36, color: const Color(0xFFEEEEEE)),
          Expanded(child: _tickerItem('BANKNIFTY', _bankNiftyPrice, _bankNiftyChange, _bankNiftyPct)),
        ],
      ),
    );
  }

  Widget _tickerItem(String label, double price, double change, double pct) {
    final isUp    = change >= 0;
    final color   = isUp ? const Color(0xFF1B8A3D) : AppColors.primaryRed;
    final sign    = isUp ? '+' : '';
    final arrow   = isUp ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF555555))),
          const SizedBox(height: 3),
          Text(
            price.toStringAsFixed(2),
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Color(0xFF1A1A1A)),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Icon(arrow, size: 16, color: color),
              Text(
                '$sign${change.toStringAsFixed(2)} ($sign${pct.toStringAsFixed(2)}%)',
                style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _fmtVol(int v) {
    if (v >= 10000000) return '${(v / 10000000).toStringAsFixed(2)} Cr';
    if (v >= 100000)   return '${(v / 100000).toStringAsFixed(2)} L';
    return v.toString();
  }

  Widget _niftyDetails() {
    final isUp     = _niftyChange >= 0;
    final upColor  = const Color(0xFF1B8A3D);
    final dnColor  = AppColors.primaryRed;
    final ltpColor = isUp ? upColor : dnColor;
    final sign     = isUp ? '+' : '';

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8E8E8)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Tappable header ─────────────────────────────────────────
          GestureDetector(
            onTap: () => setState(() => _niftyExpanded = !_niftyExpanded),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: ltpColor.withOpacity(0.06),
                borderRadius: BorderRadius.vertical(
                  top: const Radius.circular(14),
                  bottom: Radius.circular(_niftyExpanded ? 0 : 14),
                ),
              ),
              child: Row(
                children: [
                  Text('NIFTY 50',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: ltpColor)),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: ltpColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text('NSE',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: ltpColor)),
                  ),
                  const SizedBox(width: 10),
                  // change pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: ltpColor.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      '$sign${_niftyChange.toStringAsFixed(2)} ($sign${_niftyPct.toStringAsFixed(2)}%)',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: ltpColor),
                    ),
                  ),
                  const Spacer(),
                  Text(_niftyPrice.toStringAsFixed(2),
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: ltpColor)),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: _niftyExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: Icon(Icons.keyboard_arrow_down_rounded,
                        size: 20, color: ltpColor),
                  ),
                ],
              ),
            ),
          ),
          // ── Expandable OHLC body ─────────────────────────────────────
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity, height: 0),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                children: [
                  Row(
                    children: [
                      _detailCell('Open',       _niftyOpen.toStringAsFixed(2),      Colors.black87),
                      _detailCell('High',       _niftyHigh.toStringAsFixed(2),      upColor),
                      _detailCell('Low',        _niftyLow.toStringAsFixed(2),       dnColor),
                      _detailCell('Prev Close', _niftyPrevClose.toStringAsFixed(2), Colors.black87),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(height: 1, color: Color(0xFFF0F0F0)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _detailCell('Volume',   _fmtVol(_niftyVolume),            Colors.black87),
                      _detailCell('52W High', _nifty52wHigh.toStringAsFixed(2), upColor),
                      _detailCell('52W Low',  _nifty52wLow.toStringAsFixed(2),  dnColor),
                      _detailCell('Circuit',  'No Band',                         Colors.grey),
                    ],
                  ),
                ],
              ),
            ),
            crossFadeState: _niftyExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }

  Widget _detailCell(String label, String value, Color valueColor) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 10, color: Color(0xFF888888), fontWeight: FontWeight.w500)),
          const SizedBox(height: 3),
          Text(value,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: valueColor)),
        ],
      ),
    );
  }

  Widget _actionButtons() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 14),
      child: Row(
        children: [
          _premiumOutlineButton(
            text: "Market Watch",
            icon: Icons.show_chart,
            onTap: () => Navigator.pushNamed(context, AppRoutes.marketWatch),
          ),
          const SizedBox(width: 10),
          _premiumFilledButton(
            text: "Set MW",
            icon: Icons.add_chart,
            onTap: () => Navigator.pushNamed(context, AppRoutes.setMW),
          ),
          const SizedBox(width: 10),
          _premiumFilledButton(
            text: "Reg / Login",
            icon: Icons.login,
            onTap: () => Navigator.pushNamed(context, AppRoutes.regLogin),
          ),
        ],
      ),
    );
  }
  Widget _premiumOutlineButton({
    required String text,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.red.shade700, width: 1.4),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: Colors.red.shade700),
              const SizedBox(width: 6),
              Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.red.shade700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }Widget _premiumFilledButton({
    required String text,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: AppColors.buttonPrimary,
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.35),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: Colors.white),
              const SizedBox(width: 6),
              Text(
                text,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  //
  // // 📌 Tabs
  // Widget _tabBar() {
  //   return Container(
  //     color: Colors.grey.shade200,
  //     child: Row(
  //       children: [
  //         _tabItem("Trading Tips", true),
  //         _tabItem("History", false),
  //         _tabItem("Ask", false),
  //       ],
  //     ),
  //   );
  // }
  //
  // Widget _tabItem(String title, bool active) {
  //   return Expanded(
  //     child: Container(
  //       padding: const EdgeInsets.symmetric(vertical: 10),
  //       color: active ? Colors.white : Colors.grey.shade300,
  //       child: Center(
  //         child: Text(
  //           title,
  //           style: TextStyle(
  //               fontWeight:
  //               active ? FontWeight.bold : FontWeight.normal),
  //         ),
  //       ),
  //     ),
  //   );
  // }
  //
  // // 🔘 Buttons Row
  // Widget _actionButtons() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
  //     child: Row(
  //       children: [
  //         _outlineButton("Market Watch"),
  //         const SizedBox(width: 8),
  //         _filledButton("Set MW"),
  //         const SizedBox(width: 8),
  //         _filledButton("Reg/Login"),
  //       ],
  //     ),
  //   );
  // }

  // ─── SCROLLABLE BODY ──────────────────────────────────────────────────────

  Widget _scrollableBody() {
    // Ask tab needs its own layout: scrollable chat + fixed input bar
    if (_selectedTab == 2) {
      return Column(
        children: [
          _actionButtons(),
          Expanded(child: _askTab()),
        ],
      );
    }
    // All other tabs: one continuous scroll
    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _actionButtons(),
          _liveTicker(),
          _niftyDetails(),
          _tabContent(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ─── TAB CONTENT ──────────────────────────────────────────────────────────

  Widget _tabContent() {
    switch (_selectedTab) {
      case 1:  return _historyTab();
      default: return _tradingTipsTab();
    }
  }

  // ── Tab 0: Trading Tips — Advisory List ───────────────────────────────────

  static const _advisors = [
    _Advisor(initials: 'RK', name: 'Rajesh Kumar', role: 'Senior Analyst', price: 2999, experience: 12, expertise: ['Equity', 'F&O', 'Index'], rating: 4.8),
    _Advisor(initials: 'PS', name: 'Priya Sharma', role: 'Commodity Expert', price: 1999, experience: 8,  expertise: ['Commodity', 'MCX', 'Crude'], rating: 4.6),
    _Advisor(initials: 'AM', name: 'Anil Mehta',   role: 'Options Trader',  price: 3499, experience: 15, expertise: ['Options', 'Nifty', 'BankNifty'], rating: 4.9),
    _Advisor(initials: 'SP', name: 'Sunita Patel', role: 'Currency Analyst', price: 1499, experience: 6,  expertise: ['Currency', 'Forex', 'USD/INR'], rating: 4.4),
    _Advisor(initials: 'VG', name: 'Vikram Gupta', role: 'Technical Analyst', price: 2499, experience: 10, expertise: ['Technical', 'Intraday', 'Swing'], rating: 4.7),
  ];

  Widget _tradingTipsTab() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 0),
      itemCount: _advisors.length,
      itemBuilder: (_, i) => _advisorCard(_advisors[i]),
    );
  }

  Widget _advisorCard(_Advisor a) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEEEEEE)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: AppColors.primaryRed.withOpacity(0.12),
            child: Text(a.initials,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.primaryRed)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(a.name,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 14, color: Color(0xFFFFA000)),
                        const SizedBox(width: 2),
                        Text('${a.rating}',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFFFFA000))),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(a.role,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF777777))),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: a.expertise.map((tag) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F3F3),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(tag,
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF444444))),
                  )).toList(),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.workspace_premium_outlined, size: 13, color: Color(0xFF777777)),
                    const SizedBox(width: 4),
                    Text('${a.experience} yrs exp',
                        style: const TextStyle(fontSize: 11, color: Color(0xFF777777))),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.primaryRed,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('₹${a.price}/mo',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Tab 1: History ─────────────────────────────────────────────────────────

  static const _historyItems = [
    _HistoryItem(advisor: 'Rajesh Kumar', date: 'Today, 10:15 AM',   type: 'Index Tip',  status: 'Active',   summary: 'Nifty 22,500 CE — Buy above 22,450, Target 22,680, SL 22,300'),
    _HistoryItem(advisor: 'Anil Mehta',   date: 'Yesterday, 2:30 PM', type: 'Options',    status: 'Closed',   summary: 'BankNifty 48,000 PE — Booked profit at ₹185 (Entry ₹120)'),
    _HistoryItem(advisor: 'Priya Sharma', date: '1 Jul, 11:00 AM',   type: 'Commodity',  status: 'Expired',  summary: 'Gold MCX 71,000 Buy — Target not achieved, expired at close'),
    _HistoryItem(advisor: 'Vikram Gupta', date: '30 Jun, 9:30 AM',   type: 'Intraday',   status: 'Closed',   summary: 'Nifty Fut — Sell 22,350, Target 22,200 hit. Profit ₹7,500'),
    _HistoryItem(advisor: 'Sunita Patel', date: '28 Jun, 3:00 PM',   type: 'Currency',   status: 'Closed',   summary: 'USD/INR 83.50 CE — Partial exit at ₹0.32, rest expired'),
    _HistoryItem(advisor: 'Anil Mehta',   date: '27 Jun, 10:45 AM',  type: 'Options',    status: 'Active',   summary: 'Nifty 23,000 CE — Long-term hold, exp 31 Jul'),
  ];

  Widget _historyTab() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 0),
      itemCount: _historyItems.length,
      itemBuilder: (_, i) => _historyCard(_historyItems[i]),
    );
  }

  Widget _historyCard(_HistoryItem h) {
    final Color statusColor;
    final Color statusBg;
    switch (h.status) {
      case 'Active':
        statusColor = const Color(0xFF1B8A3D); statusBg = const Color(0xFFE8F5E9); break;
      case 'Expired':
        statusColor = const Color(0xFF888888); statusBg = const Color(0xFFF5F5F5); break;
      default:
        statusColor = AppColors.primaryRed;    statusBg = const Color(0xFFFDECEC);
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEEEEEE)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(h.advisor,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(6)),
                child: Text(h.status,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: statusColor)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primaryRed.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(h.type,
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.primaryRed)),
              ),
              const SizedBox(width: 8),
              Text(h.date, style: const TextStyle(fontSize: 11, color: Color(0xFF888888))),
            ],
          ),
          const SizedBox(height: 8),
          Text(h.summary,
              style: const TextStyle(fontSize: 12, color: Color(0xFF444444), height: 1.4)),
        ],
      ),
    );
  }

  // ── Tab 2: Ask — Chatbot ───────────────────────────────────────────────────

  void _sendMessage() {
    final text = _chatInput.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _chatMessages.add(_ChatMsg(text, true, _nowTime()));
      _chatInput.clear();
    });
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() {
        _chatMessages.add(_ChatMsg(_botReply(text), false, _nowTime()));
      });
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_chatScroll.hasClients) {
          _chatScroll.animateTo(
            _chatScroll.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }

  String _nowTime() {
    final now = DateTime.now();
    final h = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final m = now.minute.toString().padLeft(2, '0');
    final p = now.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $p';
  }

  String _botReply(String msg) {
    final lower = msg.toLowerCase();
    if (lower.contains('nifty'))      return 'Nifty is trading at ${_niftyPrice.toStringAsFixed(2)}. Current trend is ${_niftyChange >= 0 ? "bullish" : "bearish"}. Watch the 22,200 support level closely.';
    if (lower.contains('banknifty') || lower.contains('bank nifty')) return 'BankNifty at ${_bankNiftyPrice.toStringAsFixed(2)}. ${_bankNiftyChange >= 0 ? "Positive" : "Negative"} momentum. Key level: 48,000.';
    if (lower.contains('buy'))        return 'Always do your own analysis before buying. Our advisors recommend strict stop-loss for every trade.';
    if (lower.contains('sell'))       return 'Review your exit strategy carefully. Book profits at predefined targets and respect stop-losses.';
    if (lower.contains('gold'))       return 'Gold MCX is around ₹71,285. Bullish above ₹71,000. Consider 71,500 CE for short-term gains.';
    if (lower.contains('option'))     return 'For options, check IV before buying. High IV means expensive premiums. Consider spreads to reduce cost.';
    if (lower.contains('hello') || lower.contains('hi')) return 'Hello! I am your Say Mira trading assistant. Ask me about Nifty, BankNifty, Gold, Options, or any market queries!';
    return 'Great question! Our experts are analyzing the market. For personalized advice, subscribe to one of our premium advisory plans.';
  }

  Widget _askTab() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _chatScroll,
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            itemCount: _chatMessages.length,
            itemBuilder: (_, i) => _chatBubble(_chatMessages[i]),
          ),
        ),
        _chatInputBar(),
      ],
    );
  }

  Widget _chatBubble(_ChatMsg msg) {
    final isUser = msg.isUser;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 14,
              backgroundColor: AppColors.primaryRed.withOpacity(0.12),
              child: Text('SM', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: AppColors.primaryRed)),
            ),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                  decoration: BoxDecoration(
                    color: isUser ? AppColors.primaryRed : const Color(0xFFF4F4F4),
                    borderRadius: BorderRadius.only(
                      topLeft:     const Radius.circular(14),
                      topRight:    const Radius.circular(14),
                      bottomLeft:  Radius.circular(isUser ? 14 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 14),
                    ),
                  ),
                  child: Text(msg.text,
                      style: TextStyle(
                          fontSize: 13,
                          color: isUser ? Colors.white : const Color(0xFF1A1A1A),
                          height: 1.4)),
                ),
                const SizedBox(height: 3),
                Text(msg.time,
                    style: const TextStyle(fontSize: 10, color: Color(0xFFAAAAAA))),
              ],
            ),
          ),
          if (isUser) const SizedBox(width: 6),
        ],
      ),
    );
  }

  Widget _chatInputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _chatInput,
              onSubmitted: (_) => _sendMessage(),
              textInputAction: TextInputAction.send,
              decoration: InputDecoration(
                hintText: 'Ask about Nifty, options, tips...',
                hintStyle: const TextStyle(fontSize: 13, color: Color(0xFFAAAAAA)),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: AppColors.primaryRed),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primaryRed,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _outlineButton(String text) {
    return Expanded(
      child: OutlinedButton(

        onPressed: () {},
        child: Text(text),
      ),
    );
  }

  Widget _filledButton(String text) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonPrimary,
        ),
        onPressed: () {},
        child: Text(text,
          style: TextStyle(
              color: AppColors.textWhite
          ),),
      ),
    );
  }
}

// ===================== DATA MODELS =====================

class _Advisor {
  final String initials;
  final String name;
  final String role;
  final int    price;
  final int    experience;
  final List<String> expertise;
  final double rating;
  const _Advisor({required this.initials, required this.name, required this.role,
      required this.price, required this.experience, required this.expertise, required this.rating});
}

class _HistoryItem {
  final String advisor;
  final String date;
  final String type;
  final String status;
  final String summary;
  const _HistoryItem({required this.advisor, required this.date, required this.type,
      required this.status, required this.summary});
}

class _ChatMsg {
  final String text;
  final bool   isUser;
  final String time;
  const _ChatMsg(this.text, this.isUser, this.time);
}

// ===================== TIP ITEM =====================

class _TipItem extends StatelessWidget {
  final String text;
  const _TipItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          text,
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
    );
  }
}