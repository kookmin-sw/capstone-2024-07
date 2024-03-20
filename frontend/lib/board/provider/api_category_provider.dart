// board에서 선택한 게시판과 관련된 data들을 관리하는 provider들
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryTitleProvider = StateProvider<String>((ref) => '');

final isHotProvider = StateProvider<bool>((ref) => true);