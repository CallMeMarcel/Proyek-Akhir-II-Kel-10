import AdminLayout from "@/Layouts/AdminLayout";
import { Link } from "@inertiajs/react";

export default function OrderIndex({ orders }) {
    return (
        <AdminLayout>
            <div className="p-6 bg-white rounded shadow">
                <div className="flex justify-between items-center mb-4">
                    <h2 className="text-2xl font-bold">Daftar Manual Order</h2>
                    <Link
                        href={route("admin.order.create")}
                        className="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700"
                    >
                        + Buat Order Manual
                    </Link>
                </div>

                <table className="min-w-full divide-y divide-gray-200">
                    <thead className="bg-gray-100">
                        <tr>
                            <th className="px-4 py-2 text-left text-sm font-medium text-gray-600">Order ID</th>
                            <th className="px-4 py-2 text-left text-sm font-medium text-gray-600">Customer</th>
                            <th className="px-4 py-2 text-left text-sm font-medium text-gray-600">Total</th>
                            <th className="px-4 py-2 text-left text-sm font-medium text-gray-600">Status</th>
                            <th className="px-4 py-2 text-left text-sm font-medium text-gray-600">Action</th>
                        </tr>
                    </thead>
                    <tbody className="bg-white divide-y divide-gray-200">
                        {orders.map((order) => (
                            <tr key={order.id}>
                                <td className="px-4 py-2">{order.id}</td>
                                <td className="px-4 py-2">{order.user?. name || "-"}</td>
                                <td className="px-4 py-2">
                                    Rp {Number(order.price).toLocaleString("id-ID")}
                                </td>
                                <td className="px-4 py-2">{order.status.charAt(0).toUpperCase() + order.status.slice(1)}</td>
                                <td className="px-4 py-2">{order.snap_token || "-"}</td>

                                <td className="px-4 py-2">
                                    <Link
                                        href={route("orders.show", order.id)}
                                        className="bg-blue-500 text-white px-3 py-1 rounded hover:bg-blue-600"
                                    >
                                        Detail
                                    </Link>
                                </td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            </div>
        </AdminLayout>
    );
}
