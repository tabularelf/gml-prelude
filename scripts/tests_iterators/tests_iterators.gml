/* Tests iterator behaviour
 * Kat @Katsaii
 */

var array_iter = iterator([1, 2, 3]);

assert_eq(1, next(array_iter));

assert_eq([2, 3], iterate(array_iter));

assert_eq([undefined, undefined, undefined], take(3, array_iter));

var struct = {
	pos : 0,
	__next__ : function() {
		pos += 1;
		return pos;
	}
};

var struct_iter = iterator(struct);

assert_eq([1, 2, 3, 4], take(4, struct_iter));

drop(4, struct_iter); // [5, 6, 7, 8]

assert_eq([9], take(1, struct_iter));

assert_eq([], take(0, struct_iter));

var enum_iter = enumerate(iterator(["A", "B", "C", "D", "D", "F", "K"]));

assert_eq([0, "A"], peek(enum_iter));
assert_eq([0, "A"], next(enum_iter));

assert_eq([[1, "B"], [2, "C"], [3, "D"], [4, "D"]], take(4, enum_iter));

assert_eq([[5, "F"], [6, "K"]], iterate(enum_iter));

assert_eq(undefined, next(enum_iter));

var concat_iter = flatten(enumerate(iterator(["X", "Y", "Z"])));

assert_eq([0, "X", 1, "Y", 2, "Z"], iterate(concat_iter));

var map_iter = mapf(function(_x) { return _x * _x; }, iterator([0, 1, 2, 3, 4]));

assert_eq([0, 1, 4, 9, 16], iterate(map_iter));

var my_arr = ["A", "B", "C"];
var list_iter = iterator(my_arr);
var my_list = fold(func_ptr(ds_list_add), ds_list_create(), list_iter);

for (var i = 0; i < 3; i += 1) {
	assert_eq(my_arr[i], my_list[| i]);
}

var filter_iter = filter(op_less(3), iterator([1, 2, 3, 4, 5, -1, -1, -2]));

assert_eq([1, 2, -1, -1, -2], iterate(filter_iter));