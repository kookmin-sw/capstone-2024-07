import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:frontend/board/component/board_card.dart';
import 'package:frontend/board/layout/study_box_layout.dart';
import 'package:frontend/board/model/msg_board_detail_response_model.dart';
import 'package:frontend/board/provider/api_category_provider.dart';
import 'package:frontend/board/provider/board_add_provider.dart';
import 'package:frontend/board/provider/board_detail_state_notifier_provider.dart';
import 'package:frontend/board/provider/board_state_notifier_provider.dart';
import 'package:frontend/board/const/categorys.dart';
import 'package:frontend/board/provider/category_provider.dart';
import 'package:frontend/board/provider/comment_pagination_provider.dart';
import 'package:frontend/board/provider/payload_state_notifier_provider.dart';
import 'package:frontend/board/view/msg_board_add_screen.dart';
import 'package:frontend/board/view/msg_board_screen.dart';
import 'package:frontend/board/view/search_screen.dart';
import 'package:frontend/common/const/colors.dart';
import 'package:frontend/board/model/msg_board_response_model.dart';

import 'package:frontend/common/model/cursor_pagination_model.dart';
import 'package:frontend/common/provider/dio_provider.dart';
import 'package:frontend/member/provider/mypage/my_comment_state_notifier_provider.dart';

import '../../common/const/data.dart';
import '../../member/model/member_model.dart';
import '../../member/provider/member_state_notifier_provider.dart';
import '../../member/view/my_page_screen.dart';
import '../component/category_circle_with_provider.dart';

class MsgBoardListScreen extends ConsumerStatefulWidget {
  static String get routeName => 'boardList';

  const MsgBoardListScreen({
    super.key,
  });

  @override
  ConsumerState<MsgBoardListScreen> createState() => _MsgBoardListScreenState();
}

class _MsgBoardListScreenState extends ConsumerState<MsgBoardListScreen> {
  List<String> categorys = categorysList;
  final ScrollController controller = ScrollController();
  String payload = "";

  @override
  void initState() {
    super.initState();
    controller.addListener(scrollListener);
  }

  void scrollListener() {
    if (controller.offset > controller.position.maxScrollExtent - 150) {
      ref.read(boardStateNotifierProvider.notifier).paginate(fetchMore: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    payload = ref.watch(payloadNotifier);
    if (payload != "") {
      debugPrint("Show Payload Page : $payload");
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        await ref.read(payloadNotifier.notifier).add("");
        ref.read(boardDetailNotifier.notifier).add(int.parse(payload));
        MsgBoardDetailResponseModel resp;
        ref
            .read(commentPaginationProvider.notifier)
            .paginate(forceRefetch: true);
        ref.read(myCommentStateNotifierProvider.notifier).lastId =
            9223372036854775807;
        ref
            .read(myCommentStateNotifierProvider.notifier)
            .paginate(forceRefetch: true);
        ref.watch(boardAddProvider).get(int.parse(payload)).then((value) {
          resp = value;
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MsgBoardScreen(
                      board: resp,
                    ),
                fullscreenDialog: true),
          );
        });
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            renderTop(),
            renderCategories(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  ref.read(boardStateNotifierProvider.notifier).lastId =
                      9223372036854775807;
                  await ref
                      .read(boardStateNotifierProvider.notifier)
                      .paginate(forceRefetch: true);
                },
                child: ListView(
                  controller: controller,
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    renderStudyList(),
                    // adSlider(),
                    renderBoardList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            right: 10,
            bottom: 30,
            child: FloatingActionButton(
              heroTag: 'addButton',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => MsgBoardAddScreen(
                      isEdit: false,
                      board: MsgBoardResponseModel(
                        id: 0,
                        userId: 0,
                        userNickname: "",
                        universityName: "",
                        communityId: 0,
                        communityTitle: "",
                        postTitle: "",
                        postContent: "",
                        images: [],
                        count: ReactCountModel(
                            commentReplyCount: 0, likeCount: 0, scrapCount: 0),
                        isQuestion: false,
                        isBlockedUser: false,
                        createdDateTime: "",
                        imageCount: 0,
                      ),
                    ),
                  ),
                );
              },
              shape: const CircleBorder(),
              backgroundColor: FLOATING_BUTTON_COLOR,
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget renderMajorSelectBox() {
    final memberState = ref.watch(memberStateNotifierProvider);

    String major = "";
    String minor = "";
    String activatedMajor = "";

    if (memberState is MemberModel) {
      major = memberState.major;
      minor = memberState.minor;
      activatedMajor = memberState.activatedDepartment;
    }

    List<String> majors = [];
    if (activatedMajor == major) {
      majors.add(major);
      if (minor.isNotEmpty) majors.add(minor);
    } else {
      majors = [minor, major];
    }

    final dio = ref.watch(dioProvider);

    return Container(
      height: 30,
      padding: const EdgeInsets.only(left: 12, right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: MAJOR_SELECT_COLOR,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: activatedMajor,
          onChanged: (String? newValue) async {
            if (newValue != null && activatedMajor != newValue) {
              try {
                // 활성화된 전공을 변경하는 API 요청을 보낸다.
                final resp = await dio.put(
                  '$ip/api/belongs/switch-departments',
                  options: Options(
                    headers: {
                      'accessToken': 'true',
                    },
                  ),
                );
                if (resp.statusCode == 200) {
                  // 다시 paginate api 요청을 보낸다.
                  ref.read(memberStateNotifierProvider.notifier).getMe();
                  ref.read(boardStateNotifierProvider.notifier).lastId =
                      9223372036854775807;
                  ref
                      .read(boardStateNotifierProvider.notifier)
                      .paginate(forceRefetch: true);
                }
              } catch (e) {
                debugPrint("Select Major Error : $e");
              }
            }
          },
          icon: const Icon(
            Icons.arrow_drop_down,
            color: Colors.black,
          ),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 10,
            fontWeight: FontWeight.w400,
          ),
          underline: Container(),
          elevation: 0,
          dropdownColor: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
          items: majors.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                overflow: TextOverflow.fade,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget renderTop() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
      height: 50.0,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          renderMajorSelectBox(),
          Row(
            children: [
              SizedBox(
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const SearchScreen(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const MyPageScreen(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget renderCategories() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: SizedBox(
        height: 40,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            for (var category in categorys)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                child: CategoryCircleWithProvider(
                  category: category,
                  categoryCode: categoryCodesList[category]!,
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget renderBoardList() {
    final data = ref.watch(boardStateNotifierProvider);

    if (data is CursorPaginationModelLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: PRIMARY_COLOR,
        ),
      );
    }

    if (data is CursorPaginationModelError) {
      return const Center(
        child: Text("데이터를 불러올 수 없습니다."),
      );
    }

    final cp = data as CursorPaginationModel;
    for (int i = cp.data.length - 1; i >= 0; i--) {
      final MsgBoardResponseModel pItem = cp.data[i];
      if (pItem.isBlockedUser) {
        cp.data.removeAt(i);
      }
    }

    if (cp.data.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height / 3),
          const Text(
            "해당 게시판에 작성된 게시글이 없습니다.",
            style: TextStyle(color: BOARD_CARD_TIME_COLOR, fontSize: 16.0),
          ),
        ],
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cp.data.length + 1,
      itemBuilder: (_, index) {
        if (index == cp.data.length) {
          return Center(
            child: cp is CursorPaginationModelFetchingMore
                ? const CircularProgressIndicator(
                    color: PRIMARY_COLOR,
                  )
                : const Text(
                    'Copyright 2024. Decl Team all rights reserved.\n',
                    style: TextStyle(
                      color: BODY_TEXT_COLOR,
                      fontSize: 12.0,
                    ),
                  ),
          );
        }

        final MsgBoardResponseModel pItem = cp.data[index];

        return GestureDetector(
          child: BoardCard.fromModel(msgBoardResponseModel: pItem),
          onTap: () async {
            // 상세페이지
            ref.read(boardDetailNotifier.notifier).add(pItem.id);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => MsgBoardScreen(
                  board: pItem,
                ),
              ),
            );
          },
        );
      },
      separatorBuilder: (_, index) {
        return const SizedBox(height: 10.0);
      },
    );
  }

  Widget renderStudyList() {
    final communityTitle = ref.watch(categoryTitleProvider);
    final isHot = ref.watch(isHotProvider);
    if (communityTitle == null && !isHot) {
      return Padding(
        padding: const EdgeInsets.only(
          top: 10.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "최신 스터디, 프로젝트",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                    ),
                  ),
                  GestureDetector(
                    child: const Text(
                      "더 보기 >",
                      style: TextStyle(
                        color: CLOUD_COLOR,
                        fontWeight: FontWeight.w400,
                        fontSize: 10,
                      ),
                    ),
                    onTap: () {
                      ref.read(categoryTitleProvider.notifier).state = "STUDY";
                      ref.read(isHotProvider.notifier).state = false;

                      ref.read(categoryStateProvider.notifier).clear();
                      ref.read(categoryStateProvider.notifier).add("스터디/프로젝트");
                    },
                  ),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (int i = 0; i < 10; i++)
                        const Padding(
                          padding: EdgeInsets.only(
                            left: 10.0,
                            right: 5.0,
                            top: 5.0,
                            bottom: 17.0,
                          ),
                          child: StudyBox(),
                        )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return const SizedBox(
        width: 0,
      );
    }
  }

  Widget adSlider() {
    int current = 0;
    final CarouselController controller = CarouselController();
    List imageList = [
      "https://pixabay.com/get/gdf303026c09bdf863eba76c3a8d6d15d33a5e34fce3ee8cc20c194efaa47defe8bddabaa5495f7b7cb86ec9665624920e2bfdc7f049c4f00e3204b5e0576b65d_1280.jpg",
      "https://pixabay.com/get/g1e0d0f74fa4ab562447367cca607a66330d4d7a08e25686857a2930f6702ff267ecc3249d4e26ab42c2d168a9c625ce0a2426f940e941733bed5177ce911e897_1280.jpg",
      "https://pixabay.com/get/g751c4c7eaa244b2d9b7fbe2079894f55293c50f65265cc603d1831d8c5bd542db385ff397039e10bd23bedac1824413c02517dcbe71cc51f1c06a45ddf4cea22_1280.jpg",
      "https://pixabay.com/get/gdab65061a6f72817e4c983087119f3e688af08ca44de4cce98401b5ed401a5b3252e6a880681fd6bc45eab42220f25646254a712a4ef7df6903e3cef0467fcd7_1280.jpg",
    ];
    return CarouselSlider(
      carouselController: controller,
      items: imageList.map(
        (imgLink) {
          return Builder(
            builder: (context) {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Image(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                    imgLink,
                  ),
                ),
              );
            },
          );
        },
      ).toList(),
      options: CarouselOptions(
        height: 300,
        viewportFraction: 1.0,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 4),
        onPageChanged: (index, reason) {
          // TODO : set current
        },
      ),
    );
  }
}
