# AMBA APB Protocol Verification Environment  

Welcome to the **UVM Universal Verification Component (UVC)** for the **AMBA APB Protocol**. This environment is designed for verifying both **APB Master** and **APB Slave** devices, ensuring compliance with the AMBA 3.0 APB specification. It includes precise **functional coverage**, a reusable and scalable UVM testbench, and a sample **Slave Device Under Test (DUT)**.  

---

## About the AMBA APB Protocol  

The **Advanced Microcontroller Bus Architecture (AMBA) APB** is a simple, low-power interface used for connecting peripherals.  
It is designed for:
- **Read/Write Transactions**: Communication between master and slave devices.
- **Efficiency**: Optimized for low-frequency, low-power operations.

### Key Signals  

| **Signal**  | **Direction** | **Description**                                                                                 |  
|-------------|---------------|-------------------------------------------------------------------------------------------------|  
| `pclk`      | Input         | Clock signal used for synchronization.                                                          |  
| `rst_n`     | Input         | Active-low reset signal to initialize the interface.                                            |  
| `psel`      | Input         | Select signal to indicate that the slave is active.                                             |  
| `penable`   | Input         | Signal indicating the second phase of an APB transfer.                                          |  
| `paddr`     | Input         | Address bus used to select a register or memory location in the slave.                          |  
| `pwrite`    | Input         | Write control signal (`1` for write, `0` for read).                                             |  
| `pwdata`    | Input         | Write data bus containing data from the master.                                                 |  
| `prdata`    | Output        | Read data bus containing data from the slave.                                                   |  
| `pready`    | Output        | Ready signal to indicate the completion of a transaction.                                       |  

---

## Features of the UVM Environment  

1. **Support for Both Master and Slave Verification**  
   - The environment can be configured to verify **APB Master** or **APB Slave** implementations.  

2. **Precise Coverage**  
   - Includes detailed **functional coverage** to ensure all aspects of the protocol are exercised.  

3. **Reusable and Scalable**  
   - Developed using UVM, making it modular and easy to adapt to new DUTs.  

4. **Pre-Integrated Slave DUT**  
   - The repository includes a **Slave DUT** for demonstration and testing purposes.  

---

## How to Run the Simulation  

For this you should have simulator like Cadence Incisive/Xcelium or equivalent tool with UVM support.

1. **Clone the Repository**  
   ```bash
   git clone https://github.com/rivki-beker/apb-uvc.git
   ```  

2. **Navigate to the Testbench Directory**  
   ```bash
   cd tb
   ```  

3. **Navigate to the Testbench Directory**  
   ```bash
   cd tb
   ```  

4. **Run the Simulation**  
   ```bash
   xrun -f run.f -gui -access rwc
   ```  

5. **View the Waveforms**  
   Use the GUI mode to observe the waveforms and verify functionality:  
   ![Waveform Example](docs/waveform.png)  

6. **Analyze the Coverage**  
   Functional coverage is automatically collected and reported.  

---

## Summary  

This **UVM UVC** for the AMBA APB Protocol offers a complete and robust solution for verifying both APB Masters and Slaves. It integrates reusable components, precise coverage, and a pre-configured DUT to facilitate easy setup and testing.