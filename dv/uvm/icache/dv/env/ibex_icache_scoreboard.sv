// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

class ibex_icache_scoreboard
  extends dv_base_scoreboard #(.CFG_T(ibex_icache_env_cfg), .COV_T(ibex_icache_env_cov));

  `uvm_component_utils(ibex_icache_scoreboard)

  // local variables

  // TLM agent fifos
  uvm_tlm_analysis_fifo #(ibex_icache_core_bus_item) core_fifo;
  uvm_tlm_analysis_fifo #(ibex_icache_mem_bus_item)  mem_fifo;

  `uvm_component_new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    core_fifo = new("core_fifo", this);
    mem_fifo = new("mem_fifo", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    fork
      process_core_fifo();
      process_mem_fifo();
    join_none
  endtask

  virtual task process_core_fifo();
    ibex_icache_core_bus_item item;
    forever begin
      core_fifo.get(item);
      `uvm_info(`gfn, $sformatf("received core transaction:\n%0s", item.sprint()), UVM_HIGH)
    end
  endtask

  virtual task process_mem_fifo();
    ibex_icache_mem_bus_item item;
    forever begin
      mem_fifo.get(item);
      `uvm_info(`gfn, $sformatf("received mem transaction:\n%0s", item.sprint()), UVM_HIGH)
    end
  endtask

  virtual function void reset(string kind = "HARD");
    super.reset(kind);
    // reset local fifos queues and variables
  endfunction

  function void check_phase(uvm_phase phase);
    super.check_phase(phase);
    // post test checks - ensure that all local fifos and queues are empty
  endfunction

endclass
