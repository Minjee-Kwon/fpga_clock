`timescale 1ns / 1ps
module top(
    input clk,
    input reset,
    input [2:0] btn,
    input [7:0] sw,
    output [7:0] seg,
    output [3:0] an,
    output [4:0] led
    );

    wire [2:0] w_clean_btn;
    wire [13:0] w_seg_data; //FND에 max 9999의 bin 값 표시
    wire w_tick;
    wire w_anim_on;
    wire w_sw_mode;
    
    btn_debouncer u_btn_debouncer(
        .clk(clk),
        .reset(reset),
        .noisy_btn(btn),  
        .clean_btn(w_clean_btn)
    );

    // main_controller u_main_controller(
    //     .clk(clk),
    //     .reset(reset), // reset : sw15
    //     .btn(w_clean_btn),
    //     .sw(sw),
    //     .seg_data(w_seg_data),
    //     .led(led)
    // );

    mode_fsm u_mode_fsm(
        .tick(w_tick),
        .clk(clk),
        .reset(reset),
        .btn(w_clean_btn),
        .seg_data(w_seg_data),
        .led(led),
        .sw_mode(w_sw_mode),
        .anim_on(w_anim_on)
    );

    tick_generator u_tick_generator(
        .clk(clk),
        .reset(reset),
        .tick(w_tick)
    );

    fnd_controller u_fnd_controller(
        .clk(clk),
        .reset(reset),
        .tick(w_tick),
        .anim_on(w_anim_on),
        .in_data(w_seg_data),
        .sw_mode(w_sw_mode),
        .an(an),
        .seg(seg)
    );
endmodule
