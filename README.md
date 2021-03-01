# git-utils

## Installation
```bash
git clone https://github.com/zoubin/git-utils.git
cd git-utils
echo "export PATH="'"'`pwd`"/bin:\$PATH"'"' >> ~/.bash_profile
```
## git mclone
```bash
git mclone remote-url remote-url

```

## git mpull
```bash
git mpull repo-dir-1 repo-dir-2
git mpull

```

## git mgrep
```bash
mrm grep -noE keywords -- -- repo-dir-1 repo-dir-2
mrm grep -noE keywords

```

## git diff-blame
```bash
git diff-blame HEAD~3 HEAD~1 -- lib/
```

```
diff --git a/lib/BasicEvaluatedExpression.js b/lib/BasicEvaluatedExpression.js
index 559c5211..a0f7bd43 100644
--- a/lib/BasicEvaluatedExpression.js
+++ b/lib/BasicEvaluatedExpression.js
@@ -35,6 +35,7 @@ class BasicEvaluatedExpression {
 4fc5690fe (Florent Cailhol 2018-01-03 22:42:57 +0100 35) 		this.options = null;
 4fc5690fe (Florent Cailhol 2018-01-03 22:42:57 +0100 36) 		this.prefix = null;
 4fc5690fe (Florent Cailhol 2018-01-03 22:42:57 +0100 37) 		this.postfix = null;
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 38) 		this.wrappedInnerExpressions = null;
 25af83f28 (Zhibin Liu      2018-10-30 19:39:43 +0800 39) 		this.expression = null;
 b1c7d5c8c (Will Mendes     2017-01-03 08:32:23 +1100 40) 	}
 b1c7d5c8c (Will Mendes     2017-01-03 08:32:23 +1100 41) 
@@ -176,10 +177,11 @@ class BasicEvaluatedExpression {
 b1c7d5c8c (Will Mendes     2017-01-03 08:32:23 +1100 177) 		return this;
 b1c7d5c8c (Will Mendes     2017-01-03 08:32:23 +1100 178) 	}
 b1c7d5c8c (Will Mendes     2017-01-03 08:32:23 +1100 179) 
-b1c7d5c8c (Will Mendes     2017-01-03 08:32:23 +1100 179) 	setWrapped(prefix, postfix) {
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 180) 	setWrapped(prefix, postfix, innerExpressions) {
 4fc5690fe (Florent Cailhol 2018-01-03 22:42:57 +0100 181) 		this.type = TypeWrapped;
 b1c7d5c8c (Will Mendes     2017-01-03 08:32:23 +1100 182) 		this.prefix = prefix;
 b1c7d5c8c (Will Mendes     2017-01-03 08:32:23 +1100 183) 		this.postfix = postfix;
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 184) 		this.wrappedInnerExpressions = innerExpressions;
 b1c7d5c8c (Will Mendes     2017-01-03 08:32:23 +1100 185) 		return this;
 b1c7d5c8c (Will Mendes     2017-01-03 08:32:23 +1100 186) 	}
 b1c7d5c8c (Will Mendes     2017-01-03 08:32:23 +1100 187) 
diff --git a/lib/Parser.js b/lib/Parser.js
index 0ff49bb7..23a96119 100644
--- a/lib/Parser.js
+++ b/lib/Parser.js
@@ -216,62 +216,114 @@ class Parser extends Tapable {
 5238159d2 (Tobias Koppers  2018-02-25 02:00:20 +0100 216) 						right.prefix &&
 5238159d2 (Tobias Koppers  2018-02-25 02:00:20 +0100 217) 						right.prefix.isString()
 5238159d2 (Tobias Koppers  2018-02-25 02:00:20 +0100 218) 					) {
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 219) 						// "left" + ("prefix" + inner + "postfix")
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 220) 						// => ("leftprefix" + inner + "postfix")
 90f345a7a (Sergey Melyukov 2017-04-04 17:04:28 +0300 221) 						res.setWrapped(
 90f345a7a (Sergey Melyukov 2017-04-04 17:04:28 +0300 222) 							new BasicEvaluatedExpression()
 5238159d2 (Tobias Koppers  2018-02-25 02:00:20 +0100 223) 								.setString(left.string + right.prefix.string)
 5238159d2 (Tobias Koppers  2018-02-25 02:00:20 +0100 224) 								.setRange(joinRanges(left.range, right.prefix.range)),
-5238159d2 (Tobias Koppers  2018-02-25 02:00:20 +0100 223) 							right.postfix
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 225) 							right.postfix,
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 226) 							right.wrappedInnerExpressions
 5238159d2 (Tobias Koppers  2018-02-25 02:00:20 +0100 227) 						);
 5238159d2 (Tobias Koppers  2018-02-25 02:00:20 +0100 228) 					} else if (right.isWrapped()) {
-52f2daf89 (Tobias Koppers  2017-04-13 14:52:49 +0200 226) 						res.setWrapped(
-52f2daf89 (Tobias Koppers  2017-04-13 14:52:49 +0200 227) 							new BasicEvaluatedExpression()
-5238159d2 (Tobias Koppers  2018-02-25 02:00:20 +0100 228) 								.setString(left.string)
-5238159d2 (Tobias Koppers  2018-02-25 02:00:20 +0100 229) 								.setRange(left.range),
-5238159d2 (Tobias Koppers  2018-02-25 02:00:20 +0100 230) 							right.postfix
-5238159d2 (Tobias Koppers  2018-02-25 02:00:20 +0100 231) 						);
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 229) 						// "left" + ([null] + inner + "postfix")
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 230) 						// => ("left" + inner + "postfix")
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 231) 						res.setWrapped(left, right.postfix, right.wrappedInnerExpressions);
 90f345a7a (Sergey Melyukov 2017-04-04 17:04:28 +0300 232) 					} else {
-90f345a7a (Sergey Melyukov 2017-04-04 17:04:28 +0300 233) 						res.setWrapped(left, null);
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 233) 						// "left" + expr
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 234) 						// => ("left" + expr + "")
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 235) 						res.setWrapped(left, null, [right]);
 90f345a7a (Sergey Melyukov 2017-04-04 17:04:28 +0300 236) 					}
 5238159d2 (Tobias Koppers  2018-02-25 02:00:20 +0100 237) 				} else if (left.isNumber()) {
 5238159d2 (Tobias Koppers  2018-02-25 02:00:20 +0100 238) 					if (right.isString()) {
 90f345a7a (Sergey Melyukov 2017-04-04 17:04:28 +0300 239) 						res.setString(left.number + right.string);
 5238159d2 (Tobias Koppers  2018-02-25 02:00:20 +0100 240) 					} else if (right.isNumber()) {
 90f345a7a (Sergey Melyukov 2017-04-04 17:04:28 +0300 241) 						res.setNumber(left.number + right.number);
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 242) 					} else {
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 243) 						return;
 90f345a7a (Sergey Melyukov 2017-04-04 17:04:28 +0300 244) 					}
 5238159d2 (Tobias Koppers  2018-02-25 02:00:20 +0100 245) 				} else if (left.isWrapped()) {
 5238159d2 (Tobias Koppers  2018-02-25 02:00:20 +0100 246) 					if (left.postfix && left.postfix.isString() && right.isString()) {
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 247) 						// ("prefix" + inner + "postfix") + "right"
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 248) 						// => ("prefix" + inner + "postfixright")
 5238159d2 (Tobias Koppers  2018-02-25 02:00:20 +0100 249) 						res.setWrapped(
 5238159d2 (Tobias Koppers  2018-02-25 02:00:20 +0100 250) 							left.prefix,
 90f345a7a (Sergey Melyukov 2017-04-04 17:04:28 +0300 251) 							new BasicEvaluatedExpression()
 5238159d2 (Tobias Koppers  2018-02-25 02:00:20 +0100 252) 								.setString(left.postfix.string + right.string)
-5238159d2 (Tobias Koppers  2018-02-25 02:00:20 +0100 247) 								.setRange(joinRanges(left.postfix.range, right.range))
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 253) 								.setRange(joinRanges(left.postfix.range, right.range)),
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 254) 							left.wrappedInnerExpressions
 90f345a7a (Sergey Melyukov 2017-04-04 17:04:28 +0300 255) 						);
 5238159d2 (Tobias Koppers  2018-02-25 02:00:20 +0100 256) 					} else if (
 5238159d2 (Tobias Koppers  2018-02-25 02:00:20 +0100 257) 						left.postfix &&
 5238159d2 (Tobias Koppers  2018-02-25 02:00:20 +0100 258) 						left.postfix.isString() &&
 5238159d2 (Tobias Koppers  2018-02-25 02:00:20 +0100 259) 						right.isNumber()
 5238159d2 (Tobias Koppers  2018-02-25 02:00:20 +0100 260) 					) {
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 261) 						// ("prefix" + inner + "postfix") + 123
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 262) 						// => ("prefix" + inner + "postfix123")
 5238159d2 (Tobias Koppers  2018-02-25 02:00:20 +0100 263) 						res.setWrapped(
 5238159d2 (Tobias Koppers  2018-02-25 02:00:20 +0100 264) 							left.prefix,
 90f345a7a (Sergey Melyukov 2017-04-04 17:04:28 +0300 265) 							new BasicEvaluatedExpression()
 5238159d2 (Tobias Koppers  2018-02-25 02:00:20 +0100 266) 								.setString(left.postfix.string + right.number)
-5238159d2 (Tobias Koppers  2018-02-25 02:00:20 +0100 258) 								.setRange(joinRanges(left.postfix.range, right.range))
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 267) 								.setRange(joinRanges(left.postfix.range, right.range)),
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 268) 							left.wrappedInnerExpressions
 90f345a7a (Sergey Melyukov 2017-04-04 17:04:28 +0300 269) 						);
 5238159d2 (Tobias Koppers  2018-02-25 02:00:20 +0100 270) 					} else if (right.isString()) {
-90f345a7a (Sergey Melyukov 2017-04-04 17:04:28 +0300 261) 						res.setWrapped(left.prefix, right);
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 271) 						// ("prefix" + inner + [null]) + "right"
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 272) 						// => ("prefix" + inner + "right")
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 273) 						res.setWrapped(left.prefix, right, left.wrappedInnerExpressions);
 5238159d2 (Tobias Koppers  2018-02-25 02:00:20 +0100 274) 					} else if (right.isNumber()) {
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 275) 						// ("prefix" + inner + [null]) + 123
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 276) 						// => ("prefix" + inner + "123")
 5238159d2 (Tobias Koppers  2018-02-25 02:00:20 +0100 277) 						res.setWrapped(
 5238159d2 (Tobias Koppers  2018-02-25 02:00:20 +0100 278) 							left.prefix,
 90f345a7a (Sergey Melyukov 2017-04-04 17:04:28 +0300 279) 							new BasicEvaluatedExpression()
 5238159d2 (Tobias Koppers  2018-02-25 02:00:20 +0100 280) 								.setString(right.number + "")
-5238159d2 (Tobias Koppers  2018-02-25 02:00:20 +0100 267) 								.setRange(right.range)
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 281) 								.setRange(right.range),
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 282) 							left.wrappedInnerExpressions
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 283) 						);
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 284) 					} else if (right.isWrapped()) {
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 285) 						// ("prefix1" + inner1 + "postfix1") + ("prefix2" + inner2 + "postfix2")
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 286) 						// ("prefix1" + inner1 + "postfix1" + "prefix2" + inner2 + "postfix2")
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 287) 						res.setWrapped(
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 288) 							left.prefix,
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 289) 							right.postfix,
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 290) 							left.wrappedInnerExpressions &&
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 291) 								right.wrappedInnerExpressions &&
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 292) 								left.wrappedInnerExpressions
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 293) 									.concat(left.postfix ? [left.postfix] : [])
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 294) 									.concat(right.prefix ? [right.prefix] : [])
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 295) 									.concat(right.wrappedInnerExpressions)
 5238159d2 (Tobias Koppers  2018-02-25 02:00:20 +0100 296) 						);
 90f345a7a (Sergey Melyukov 2017-04-04 17:04:28 +0300 297) 					} else {
-90f345a7a (Sergey Melyukov 2017-04-04 17:04:28 +0300 270) 						res.setWrapped(left.prefix, new BasicEvaluatedExpression());
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 298) 						// ("prefix" + inner + postfix) + expr
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 299) 						// => ("prefix" + inner + postfix + expr + [null])
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 300) 						res.setWrapped(
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 301) 							left.prefix,
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 302) 							null,
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 303) 							left.wrappedInnerExpressions &&
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 304) 								left.wrappedInnerExpressions.concat(
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 305) 									left.postfix ? [left.postfix, right] : [right]
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 306) 								)
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 307) 						);
 90f345a7a (Sergey Melyukov 2017-04-04 17:04:28 +0300 308) 					}
 f53a7f3e6 (Tobias Koppers  2014-07-07 13:20:38 +0200 309) 				} else {
 5238159d2 (Tobias Koppers  2018-02-25 02:00:20 +0100 310) 					if (right.isString()) {
-90f345a7a (Sergey Melyukov 2017-04-04 17:04:28 +0300 274) 						res.setWrapped(null, right);
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 311) 						// left + "right"
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 312) 						// => ([null] + left + "right")
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 313) 						res.setWrapped(null, right, [left]);
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 314) 					} else if (right.isWrapped()) {
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 315) 						// left + (prefix + inner + "postfix")
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 316) 						// => ([null] + left + prefix + inner + "postfix")
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 317) 						res.setWrapped(
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 318) 							null,
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 319) 							right.postfix,
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 320) 							right.wrappedInnerExpressions &&
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 321) 								(right.prefix ? [left, right.prefix] : [left]).concat(
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 322) 									right.wrappedInnerExpressions
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 323) 								)
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 324) 						);
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 325) 					} else {
+babe736cf (Tobias Koppers  2018-11-05 15:17:10 +0100 326) 						return;
 90f345a7a (Sergey Melyukov 2017-04-04 17:04:28 +0300 327) 					}
 ee01837d6 (Tobias Koppers  2013-01-30 18:49:25 +0100 328) 				}
 90f345a7a (Sergey Melyukov 2017-04-04 17:04:28 +0300 329) 				res.setRange(expr.range);
diff --git a/lib/dependencies/ContextDependencyHelpers.js b/lib/dependencies/ContextDependencyHelpers.js
index 36e2dede..377425b2 100644
--- a/lib/dependencies/ContextDependencyHelpers.js
+++ b/lib/dependencies/ContextDependencyHelpers.js
@@ -180,13 +180,13 @@ ContextDependencyHelpers.create = (
 5238159d2 (Tobias Koppers 2018-02-25 02:00:20 +0100 180) 		);
 dc69f23de (Tobias Koppers 2013-02-13 14:42:34 +0100 181) 		dep.loc = expr.loc;
 61633aa91 (Tobias Koppers 2018-08-03 09:20:23 +0200 182) 		const replaces = [];
-61633aa91 (Tobias Koppers 2018-08-03 09:20:23 +0200 183) 		if (prefixRange && prefix !== prefixRaw) {
+babe736cf (Tobias Koppers 2018-11-05 15:17:10 +0100 183) 		if (prefixRange) {
 61633aa91 (Tobias Koppers 2018-08-03 09:20:23 +0200 184) 			replaces.push({
 61633aa91 (Tobias Koppers 2018-08-03 09:20:23 +0200 185) 				range: prefixRange,
 61633aa91 (Tobias Koppers 2018-08-03 09:20:23 +0200 186) 				value: JSON.stringify(prefix)
 61633aa91 (Tobias Koppers 2018-08-03 09:20:23 +0200 187) 			});
 61633aa91 (Tobias Koppers 2018-08-03 09:20:23 +0200 188) 		}
-61633aa91 (Tobias Koppers 2018-08-03 09:20:23 +0200 189) 		if (postfixRange && postfix !== postfixRaw) {
+babe736cf (Tobias Koppers 2018-11-05 15:17:10 +0100 189) 		if (postfixRange) {
 61633aa91 (Tobias Koppers 2018-08-03 09:20:23 +0200 190) 			replaces.push({
 61633aa91 (Tobias Koppers 2018-08-03 09:20:23 +0200 191) 				range: postfixRange,
 61633aa91 (Tobias Koppers 2018-08-03 09:20:23 +0200 192) 				value: JSON.stringify(postfix)
@@ -196,6 +196,13 @@ ContextDependencyHelpers.create = (
 5238159d2 (Tobias Koppers 2018-02-25 02:00:20 +0100 196) 		dep.critical =
 5238159d2 (Tobias Koppers 2018-02-25 02:00:20 +0100 197) 			options.wrappedContextCritical &&
 5238159d2 (Tobias Koppers 2018-02-25 02:00:20 +0100 198) 			"a part of the request of a dependency is an expression";
+babe736cf (Tobias Koppers 2018-11-05 15:17:10 +0100 199) 
+babe736cf (Tobias Koppers 2018-11-05 15:17:10 +0100 200) 		if (parser && param.wrappedInnerExpressions) {
+babe736cf (Tobias Koppers 2018-11-05 15:17:10 +0100 201) 			for (const part of param.wrappedInnerExpressions) {
+babe736cf (Tobias Koppers 2018-11-05 15:17:10 +0100 202) 				if (part.expression) parser.walkExpression(part.expression);
+babe736cf (Tobias Koppers 2018-11-05 15:17:10 +0100 203) 			}
+babe736cf (Tobias Koppers 2018-11-05 15:17:10 +0100 204) 		}
+babe736cf (Tobias Koppers 2018-11-05 15:17:10 +0100 205) 
 ee01837d6 (Tobias Koppers 2013-01-30 18:49:25 +0100 206) 		return dep;
 ee01837d6 (Tobias Koppers 2013-01-30 18:49:25 +0100 207) 	} else {
 61633aa91 (Tobias Koppers 2018-08-03 09:20:23 +0200 208) 		const dep = new Dep(

```

## git diff-comitter
```bash
git diff-comitter HEAD~3 HEAD~1 -- lib/
```

```
+0	-1	Will Mendes
+0	-4	Sergey Melyukov
+78	-12	Tobias Koppers
```
