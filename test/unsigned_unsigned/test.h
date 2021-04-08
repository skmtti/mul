  initial begin
    ope = MULH;
    repeat(100) begin
      #1;
      a = $urandom_range(60000);
      b = $urandom_range(60000);
      #1;
        $display("%d * %d = %d", a, b, out);
      if (out != (a * b)) begin
        $display("NG");
        fail = 1;
      end
    end

    if (fail) $display("FAIL");
    else      $display("PASS");

  end

