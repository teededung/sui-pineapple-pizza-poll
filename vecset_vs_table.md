# VecSet & Table

## English

| Criteria                  | VecSet                                                  | Table<address, bool>                                                      |
| :------------------------ | :------------------------------------------------------ | :------------------------------------------------------------------------ |
| **Complexity**            | **Simple**: Directly embedded into the parent object.   | **Complex**: Separate object, requires managing lifecycle of two objects. |
| **Gas Cost**              | **Low**: Only mutates a single object.                  | **Higher**: Costs for creating and updating two separate objects.         |
| **Performance**           | **\(O(n)\)**: Checks/inserts slow if list > 10k voters. | **\(O(1)\)**: Constant-time access even with extremely large datasets.    |
| **Suitability for Polls** | **Ideal**: Polls typically have < a few thousand votes. | **Overkill**: Adds unnecessary complexity for small-scale cases.          |
| **Best Use Cases**        | Small to medium-sized datasets, directly embedded.      | Large, flexible data maps where multiple modules need independent access. |

---

## Vietnamese

| Tiêu chí         | VecSet                                                     | Table<address, bool>                                               |
| :--------------- | :--------------------------------------------------------- | :----------------------------------------------------------------- |
| **Complexity**   | **Đơn giản**: Nhúng trực tiếp vào object cha.              | **Phức tạp**: Là object riêng, cần quản lý vòng đời của 2 objects. |
| **Gas cost**     | **Thấp**: Chỉ cần mutate 1 object duy nhất.                | **Cao hơn**: Tốn phí tạo và cập nhật cho 2 objects riêng biệt.     |
| **Performance**  | **$O(n)$**: Kiểm tra/chèn chậm nếu danh sách > 10k voters. | **$O(1)$**: Tốc độ truy xuất ổn định ngay cả với dataset cực lớn.  |
| **Phù hợp poll** | **Hoàn hảo**: Các cuộc biểu quyết thường < vài nghìn vote. | **Overkill**: Thêm sự phức tạp không cần thiết cho quy mô nhỏ.     |
| **Use case tốt** | Tập hợp dữ liệu **nhỏ đến trung bình**, nhúng trực tiếp.   | Map dữ liệu **lớn, linh hoạt**, nhiều module cần truy cập riêng.   |
