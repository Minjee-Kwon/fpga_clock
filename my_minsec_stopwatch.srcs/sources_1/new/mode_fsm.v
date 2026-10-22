`timescale 1ns / 1ps
module mode_fsm(
    input tick,
    input clk,
    input reset,
    input [2:0] btn,
    output [13:0] seg_data,
    output reg [4:0] led
    );

    // mode define 
    parameter CLOCK = 2'b00;
    parameter STOPWATCH = 2'b01;

    reg [1:0] r_mode = CLOCK;
    reg sw_running = 0;
    reg sw_clear = 0;
    //clock counter
    reg [$clog2(1000)-1:0] r_clock_1ms; //10ns counter -> 1_000_000
    reg [$clog2(60)-1:0] r_clock_sec;
    reg [$clog2(100)-1:0] r_clock_min;

    //stop_watch counter 
    reg [$clog2(10)-1:0] r_1ms_counter; //10ns counter -> 1_000_000
    reg [$clog2(100)-1:0] r_10ms_counter; //10ms counter 9999까지 count
    reg [$clog2(60)-1:0] r_sec_counter;
    reg [$clog2(100)-1:0] r_min_counter;
    //reg r_prev_btnL=0;

    //btn mode check 
    always @(posedge reset, posedge clk) begin
        if(reset) begin
            r_mode <= CLOCK;
            sw_running <= 0;
            sw_clear <= 0;
        end else begin
            sw_clear <= 0;
            case(r_mode)
                CLOCK: begin 
                    if(btn[0])begin 
                        r_mode <=STOPWATCH;
                        sw_running <= 1;
                    end
                end
                STOPWATCH: begin
                    if(btn[0]) begin
                        r_mode <= CLOCK;
                        sw_running <= 0;
                    end
                    else if(btn[2])
                        sw_running <= ~sw_running;
                    else if(btn[1]) begin
                        sw_clear <= 1;
                        sw_running <=0 ;
                    end
                end
                default : begin 
                    r_mode <= CLOCK;
                    sw_running <= 0;
                end
            endcase
        end
    end

    // clock 
    always @(posedge clk, posedge reset) begin
        if(reset) begin
            r_clock_1ms <= 0;
            r_clock_sec <= 0;
            r_clock_min <= 0;
        end else if(r_mode == CLOCK && tick) begin
            if(r_clock_1ms == 999) begin
                r_clock_1ms <= 0;
                if (r_clock_sec == 59) begin
                    r_clock_sec <= 0;
                    if(r_clock_min == 99) 
                        r_clock_min <= 0;
                    else 
                        r_clock_min <= r_clock_min + 1;
                end else r_clock_sec <= r_clock_sec + 1;
            end else r_clock_1ms <= r_clock_1ms + 1;
        end
    end

    // stopwatch
    always @(posedge clk, posedge reset) begin
        if(reset) begin
            r_1ms_counter<= 0;
            r_10ms_counter <= 0;
            r_sec_counter <= 0;
            r_min_counter <= 0;
        end else if(sw_clear) begin
            r_1ms_counter<= 0;
            r_10ms_counter <= 0;
            r_sec_counter <= 0;
            r_min_counter <= 0;
        end else if(r_mode == STOPWATCH && sw_running && tick) begin
            if(r_1ms_counter == 9) begin
                r_1ms_counter <= 0;
                if (r_10ms_counter == 99) begin
                    r_10ms_counter <= 0;
                    if(r_sec_counter == 59) begin 
                        r_sec_counter <= 0;
                        if(r_min_counter == 99) 
                            r_min_counter <= 0;
                        else r_min_counter <= r_min_counter + 1;
                    end else r_sec_counter <= r_sec_counter + 1;
                end else r_10ms_counter <= r_10ms_counter + 1;
            end else r_1ms_counter <= r_1ms_counter + 1;
        end
    end
endmodule
