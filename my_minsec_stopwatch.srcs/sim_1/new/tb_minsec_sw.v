// `timescale 1ns / 1ps

// module tb_minsec_sw();
//     reg clk;
//     reg reset;
//     reg tick;
//     reg [2:0] btn;

//     wire[13:0] seg_data;
//     wire [4:0] led;
//     wire sw_mode;
//     wire anim_on;

//     mode_fsm u_mode_fsm(
//         .tick(tick),
//         .clk(clk),
//         .reset(reset),
//         .btn(btn),
//         .seg_data(seg_data),
//         .led(led),
//         .sw_mode(sw_mode),
//         .anim_on(anim_on)
//     );

//     //clock : 100MHz
//     initial clk = 0;
//     always #5 clk = ~clk;
    
//     // 100ns마다 tick 발생 --> simulation에서 
//     initial tick = 0;
//     always begin
//         #95 tick = 1;
//         #10 tick = 0;
//     end

//     task press_btn;
//         input [2:0] value; 
//         begin
//             @(negedge clk); btn = value;
//             @(negedge clk); btn = 3'b000;
//         end
//     endtask

//     initial begin
//         reset = 1;
//         btn = 3'b000;

//         // 30ns 동안 reset 으로 상태를 초기화
//         #30;
//         reset = 0;

//         //clock mode 확인 후 stopwatch로 전환
//         #200; press_btn(3'b001);
        
//         //초기화로 0 되는거 확인 
//         #3000;
//         press_btn(3'b010);

//         //pause 후 애니메이션 5000tick 동안 실행 후 clock으로 복귀
//         press_btn(3'b100);
//         #550000;

//          press_btn(3'b001);

//         // 9. 이전 STOPWATCH 시간부터 재실행
//         #30000;

//         // 10. STOPWATCH -> CLOCK
//         press_btn(3'b001);

//         #1000;
//         $finish;
//     end
// endmodule



`timescale 1ns / 1ps

module tb_minsec_sw();
    reg clk;
    reg reset;
    reg tick;
    reg [2:0] btn;

    wire [13:0] seg_data;
    wire [4:0] led;
    wire sw_mode;
    wire anim_on;
    wire [7:0] seg;
    wire [3:0] an;

    mode_fsm u_mode_fsm(
        .tick(tick),
        .clk(clk),
        .reset(reset),
        .btn(btn),
        .seg_data(seg_data),
        .led(led),
        .sw_mode(sw_mode),
        .anim_on(anim_on)
    );

    fnd_controller u_fnd_controller(
        .clk(clk),
        .reset(reset),
        .tick(tick),
        .anim_on(anim_on),
        .sw_mode(sw_mode),
        .in_data(seg_data),
        .an(an),
        .seg(seg)
    );

    // clock : 100MHz
    initial clk = 0;
    always #5 clk = ~clk;

    // 100ns마다 tick 발생
    initial tick = 0;
    always begin
        #95 tick = 1;
        #5 tick = 0;
    end

    task press_btn;
        input [2:0] value;
        begin
            @(negedge clk);
            btn = value;
            @(negedge clk);
            btn = 3'b000;
        end
    endtask

    initial begin
        reset = 1;
        btn = 3'b000;

        // 30ns 동안 reset
        #30;
        reset = 0;

        // CLOCK 확인 후 STOPWATCH 전환
        #200;
        press_btn(3'b001);

        // STOPWATCH 카운터 증가 확인
        #30000;

        // STOPWATCH RESET
        press_btn(3'b010);

        // RESET 후 재실행 확인
        #30000;

        // STOPWATCH PAUSE
        press_btn(3'b100);

        // Circle Animation 5000tick 동안 실행
        #550000;

        // CLOCK -> STOPWATCH 재진입
        press_btn(3'b001);

        // STOPWATCH 동작 확인
        #30000;

        // STOPWATCH -> CLOCK
        press_btn(3'b001);

        #1000;
        $finish;
    end

endmodule

