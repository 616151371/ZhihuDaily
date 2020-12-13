import 'package:zhihu_daily/generated/json/base/json_convert_content.dart';
import 'package:zhihu_daily/generated/json/base/json_field.dart';

class ZhihuStoryExtraEntity with JsonConvert<ZhihuStoryExtraEntity> {
	ZhihuStoryExtraCount count;
	@JSONField(name: "vote_status")
	int voteStatus;
	bool favorite;
}

class ZhihuStoryExtraCount with JsonConvert<ZhihuStoryExtraCount> {
	@JSONField(name: "long_comments")
	int longComments;
	@JSONField(name: "short_comments")
	int shortComments;
	int comments;
	int likes;
}
