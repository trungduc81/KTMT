# Tác dụng của các thanh ghi trong EMU8086

## 1. Thanh ghi dữ liệu (Data Registers)

### AX (Accumulator Register):
- Thanh ghi này dùng để lưu trữ kết quả các phép toán số học và logic.
- **AH** (High byte of AX) và **AL** (Low byte of AX) là các phần con của **AX**.
- Thường dùng trong các phép toán **16-bit** và **8-bit**.

### BX (Base Register):
- Thanh ghi này thường được sử dụng như một thanh ghi cơ sở trong các phép toán tìm địa chỉ.
- **BH** và **BL** là các phần con của **BX** (**8-bit**).

### CX (Count Register):
- Thanh ghi này thường dùng để đếm trong các phép toán lặp, đặc biệt là trong lệnh lặp (**loop**).
- **CH** và **CL** là các phần con của **CX** (**8-bit**).

### DX (Data Register):
- Thanh ghi này dùng để lưu trữ dữ liệu phụ trợ trong các phép toán.
- **DH** và **DL** là các phần con của **DX** (**8-bit**).

## 2. Thanh ghi địa chỉ (Address Registers)

### SI (Source Index):
- Thanh ghi này thường được dùng để lưu trữ địa chỉ nguồn trong các phép toán liên quan đến chuỗi (**string operations**).

### DI (Destination Index):
- Thanh ghi này lưu trữ địa chỉ đích trong các phép toán liên quan đến chuỗi (**string operations**).

## 3. Thanh ghi chỉ mục (Pointer Registers)

### SP (Stack Pointer):
- Thanh ghi này giữ địa chỉ của phần tử trên ngăn xếp (**stack**). Khi có thao tác **PUSH** hoặc **POP**, **SP** thay đổi để chỉ vào phần tử tiếp theo trong ngăn xếp.

### BP (Base Pointer):
- Thanh ghi này dùng để tham chiếu đến các tham số trong ngăn xếp (**stack**). Trong các hàm con, nó giúp xác định vị trí của các tham số và biến cục bộ.

## 4. Thanh ghi trạng thái (Flag Registers)

### FLAGS (Flag Register):
- Thanh ghi này chứa các cờ (**flag**) biểu thị trạng thái của bộ vi xử lý sau khi thực hiện một phép toán. Các cờ phổ biến bao gồm:
  - **CF (Carry Flag)**: Chỉ ra nếu có sự chuyển dư trong phép toán cộng hoặc mượn trong phép toán trừ.
  - **ZF (Zero Flag)**: Được đặt khi kết quả của một phép toán là **0**.
  - **SF (Sign Flag)**: Chỉ ra dấu của kết quả phép toán (dương hoặc âm).
  - **OF (Overflow Flag)**: Chỉ ra nếu phép toán bị tràn (**overflow**).
  - **PF (Parity Flag)**: Dùng để kiểm tra tính chẵn lẻ của số bit trong kết quả.
  - **AF (Auxiliary Carry Flag)**: Được sử dụng trong các phép toán cộng và trừ trong **BCD** (Binary Coded Decimal).
  - **DF (Direction Flag)**: Được dùng trong các phép toán chuỗi (**string operations**), xác định hướng xử lý.
  - **TF (Trap Flag)**: Dùng để điều khiển chế độ gỡ lỗi từng bước.

## 5. Thanh ghi segment (Segment Registers)

### CS (Code Segment):
- Lưu trữ địa chỉ của đoạn mã chương trình (**code segment**).

### DS (Data Segment):
- Lưu trữ địa chỉ của đoạn dữ liệu (**data segment**).

### SS (Stack Segment):
- Lưu trữ địa chỉ của đoạn ngăn xếp (**stack segment**).

### ES (Extra Segment):
- Lưu trữ địa chỉ của đoạn phụ (**extra segment**), thường dùng trong các phép toán chuỗi (**string operations**).

---

## Tóm tắt các thanh ghi chính trong EMU8086:
- **AX, BX, CX, DX**: Các thanh ghi dữ liệu chính, dùng cho các phép toán.
- **SI, DI**: Dùng cho các phép toán liên quan đến chuỗi.
- **SP, BP**: Dùng cho ngăn xếp (**stack**).
- **CS, DS, SS, ES**: Các thanh ghi **segment**, dùng để quản lý các vùng bộ nhớ khác nhau.
- **FLAGS**: Thanh ghi trạng thái, lưu trữ các cờ (**flag**) của các phép toán.
