import 'package:zhihu_daily/entities/zhihu_story_extra_entity.dart';

zhihuStoryExtraEntityFromJson(ZhihuStoryExtraEntity data, Map<String, dynamic> json) {
	if (json['count'] != null) {
		data.count = new ZhihuStoryExtraCount().fromJson(json['count']);
	}
	if (json['vote_status'] != null) {
		data.voteStatus = json['vote_status']?.toInt();
	}
	if (json['favorite'] != null) {
		data.favorite = json['favorite'];
	}
	return data;
}

Map<String, dynamic> zhihuStoryExtraEntityToJson(ZhihuStoryExtraEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.count != null) {
		data['count'] = entity.count.toJson();
	}
	data['vote_status'] = entity.voteStatus;
	data['favorite'] = entity.favorite;
	return data;
}

zhihuStoryExtraCountFromJson(ZhihuStoryExtraCount data, Map<String, dynamic> json) {
	if (json['long_comments'] != null) {
		data.longComments = json['long_comments']?.toInt();
	}
	if (json['short_comments'] != null) {
		data.shortComments = json['short_comments']?.toInt();
	}
	if (json['comments'] != null) {
		data.comments = json['comments']?.toInt();
	}
	if (json['likes'] != null) {
		data.likes = json['likes']?.toInt();
	}
	return data;
}

Map<String, dynamic> zhihuStoryExtraCountToJson(ZhihuStoryExtraCount entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['long_comments'] = entity.longComments;
	data['short_comments'] = entity.shortComments;
	data['comments'] = entity.comments;
	data['likes'] = entity.likes;
	return data;
}