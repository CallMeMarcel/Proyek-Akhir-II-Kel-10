import { useState } from "react";
import { useForm, Link } from "@inertiajs/react";
import AdminLayout from "@/Layouts/AdminLayout";

export default function AdminManualOrderCreate({ products = [] }) {
    const { data, setData, post } = useForm({ items: [] });
    const [items, setItems] = useState([]);

    const addItem = () => {
        const newItems = [...items, { product_id: '', quantity: 1 }];
        setItems(newItems);
        setData('items', newItems);
    };

    const updateItem = (index, field, value) => {
        const newItems = [...items];
        newItems[index][field] = value;
        setItems(newItems);
        setData('items', newItems);
    };

    const removeItem = (index) => {
        const newItems = [...items];
        newItems.splice(index, 1);
        setItems(newItems);
        setData('items', newItems);
    };

    const handleSubmit = (e) => {
        e.preventDefault();
        post(route('admin.order.store'));
    };

    return (
        <AdminLayout>
            <div className="p-6 bg-white shadow-md rounded-md">
                <h2 className="text-2xl font-bold mb-4">Buat Order Manual</h2>

                <form onSubmit={handleSubmit}>
                    {items.map((item, index) => (
                        <div key={index} className="flex items-center mb-2 space-x-2">
                            <select
                                className="border p-2 rounded w-full"
                                value={item.product_id}
                                onChange={(e) => updateItem(index, 'product_id', e.target.value)}
                            >
                                <option value="">Pilih Produk</option>
                                {products.map(product => (
                                    <option key={product.id} value={product.id}>
                                        {product.title} - Rp{product.price}
                                    </option>
                                ))}
                            </select>

                            <input
                                type="number"
                                min={1}
                                value={item.quantity}
                                onChange={(e) => updateItem(index, 'quantity', e.target.value)}
                                className="border p-2 rounded w-24 text-center"
                            />

                            <button
                                type="button"
                                onClick={() => removeItem(index)}
                                className="text-red-500 hover:text-red-700"
                            >
                                Hapus
                            </button>
                        </div>
                    ))}

                    <div className="mt-4 flex gap-2">
                        <button
                            type="button"
                            onClick={addItem}
                            className="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600"
                        >
                            + Tambah Produk
                        </button>
                    </div>

                    <div className="mt-6 flex space-x-2">
                        <button
                            type="submit"
                            className="bg-green-600 text-white px-6 py-2 rounded hover:bg-green-700"
                        >
                            Simpan Order
                        </button>
                        <Link
                            href={route('admin.produk.index')}
                            className="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600"
                        >
                            Batal
                        </Link>
                    </div>
                </form>
            </div>
        </AdminLayout>
    );
}
