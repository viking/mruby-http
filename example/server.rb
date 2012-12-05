s = UV::TCP.new()
s.bind(UV::ip4_addr('127.0.0.1', 8888))
s.data = []
s.listen(200) {|s, x|
  return if x != 0
  c = s.accept()
  c.read_start {|c, b|
    h = HTTP::Parser.new()
    h.parse_request(b) {|h, r|
      #body = "hello #{r.path}"
      body = "hello"
      c.write("HTTP/1.1 200 OK\r\nContent-Length: #{body.size}\r\n\r\n#{body}") {|c, x|
        c.close()
      }
    }
  }
  s.data << c
}

UV::run()
