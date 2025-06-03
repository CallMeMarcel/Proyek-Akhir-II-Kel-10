import { useState } from "react";
import { Link, useForm } from "@inertiajs/react";
import AdminLayout from "@/Layouts/AdminLayout";

export default function Index({ orders: initialOrders = [] }) {
    const [orders, setOrders] = useState(initialOrders); // ⬅️ simpan state lokal
    const { put } = useForm();

    const handleComplete = (id) => {
        if (confirm("Tandai pesanan ini sebagai selesai?")) {
            put(route('admin.orders.complete', id), {
                preserveScroll: true,
                onSuccess: () => {
                    alert("Pesanan ditandai sebagai selesai.");

                    // Hapus dari tampilan
                    setOrders((prev) => prev.filter(order => order.id !== id));
                },
            });
        }
    };

    return (
        <AdminLayout>
            <div className="p-6 bg-white shadow-md rounded-md">
                <h2 className="text-2xl font-bold mb-4">Daftar Pesanan</h2>

                <table className="w-full border mt-4">
                    <thead>
                        <tr className="bg-gray-200">
                            <th className="p-2">Nomor Pesanan</th>
                            <th className="p-2">Pelanggan</th>
                            <th className="p-2">Total</th>
                            <th className="p-2">Status</th>
                            <th className="p-2">Produk</th>
                            <th className="p-2">Aksi</th>
                        </tr>
                    </thead>
                    <tbody>
                        {orders.length > 0 ? (
                            orders.map((order, index) => (
                                <tr key={order.id} className="border-t">
                                    <td className="p-2">{index + 1}</td>
                                    <td className="p-2">{order.user?.name || "Tidak diketahui"}</td>
                                    <td className="p-2">Rp {Number(order.total_price).toLocaleString('id-ID')}</td>
                                    <td className="p-2">{order.status}</td>
                                    <td className="p-2">
                                        <ul className="list-disc pl-4">
                                            {order.items.map((item) => (
                                                <li key={item.id}>
                                                    {item.product ? item.product.title : "Produk telah dihapus"} ({item.quantity} x Rp {Number(item.product.price).toLocaleString('id-ID')})
                                                </li>
                                            ))}
                                        </ul>
                                    </td>
                                    <td className="p-2">
                                        <button 
                                            onClick={() => handleComplete(order.id)} 
                                            className="bg-green-500 hover:bg-green-600 text-white px-3 py-1 rounded text-sm"
                                        >
                                            Selesai
                                        </button>
                                    </td>
                                </tr>
                            ))
                        ) : (
                            <tr>
                                <td colSpan="6" className="p-2 text-center">
                                    Belum ada pesanan.
                                </td>
                            </tr>
                        )}
                    </tbody>
                </table>
            </div>
        </AdminLayout>
    );
}
