defmodule Me.PageControllerTest do
  use Me.ConnCase

  test "GET / has a welcome message", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Welcome to my website"
  end

  test "GET / links to github", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "https://github.com/oneKelvinSmith"
  end

  test "GET / links to twitter", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "https://twitter.com/oneKelvinSmith"
  end

  test "GET / links to cv", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "https://stackoverflow.com/cv/oneKelvinSmith"
  end
end
