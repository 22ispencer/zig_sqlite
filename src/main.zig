const std = @import("std");
const c = @cImport({
    @cInclude("sqlite3.h");
});

pub fn main() !void {
    var db: ?*c.sqlite3 = undefined;
    var statement: ?*c.sqlite3_stmt = undefined;

    var rc: c_int = 0;

    rc = c.sqlite3_open("test.db", &db);
    defer _ = c.sqlite3_close(db);

    if (rc != c.SQLITE_OK) {
        std.debug.print("Failed to open db: {s}\n", .{c.sqlite3_errmsg(db)});
        return;
    }

    rc = c.sqlite3_prepare_v2(db, "SELECT * FROM sqlite_master WHERE type='table'", -1, &statement, 0);
    defer _ = c.sqlite3_finalize(statement);

    if (rc != c.SQLITE_OK) {
        std.debug.print("Failed to fetch data: {s}\n", .{c.sqlite3_errmsg(db)});
        return;
    }

    rc = c.sqlite3_step(statement);

    if (rc == c.SQLITE_ROW) {
        std.debug.print("{s}\n", .{c.sqlite3_column_text(statement, 0)});
    }
}
