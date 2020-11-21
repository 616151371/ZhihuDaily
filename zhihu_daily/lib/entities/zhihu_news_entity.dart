import 'package:zhihu_daily/generated/json/base/json_convert_content.dart';
import 'package:zhihu_daily/generated/json/base/json_field.dart';

class ZhihuNewsEntity with JsonConvert<ZhihuNewsEntity> {
	String date;
	List<ZhihuNewsStory> stories;
	@JSONField(name: "top_stories")
	List<ZhihuNewsTopStory> topStories;
}

class ZhihuNewsStory with JsonConvert<ZhihuNewsStory> {
	@JSONField(name: "image_hue")
	String imageHue;
	String title;
	String url;
	String hint;
	@JSONField(name: "ga_prefix")
	String gaPrefix;
	List<String> images;
	int type;
	int id;
}

class ZhihuNewsTopStory with JsonConvert<ZhihuNewsTopStory> {
	@JSONField(name: "image_hue")
	String imageHue;
	String hint;
	String url;
	String image;
	String title;
	@JSONField(name: "ga_prefix")
	String gaPrefix;
	int type;
	int id;
}
