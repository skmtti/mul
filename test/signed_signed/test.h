  initial begin
    ope = MULH;
    repeat(100) begin
      #1;
      a = $urandom_range(60000);
      a = -a;
      b = $urandom_range(60000);
      b = -b;
      #1;
        $display("%d * %d = %d (%d)", $signed(a), $signed(b), $signed(out), 
                                      $signed(a) * $signed(b));
      if ($signed(out) != ($signed(a) * $signed(b))) begin
        $display("NG");
        fail = 1;
      end
    end

    if (fail) $display("FAIL");
    else      $display("PASS");

  end

