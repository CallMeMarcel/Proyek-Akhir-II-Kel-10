import { Link, usePage } from "@inertiajs/react";
import {
    FiLogOut, FiGrid, FiShoppingCart,
    FiFolder, FiClipboard, FiPlusSquare
} from "react-icons/fi";

export default function AdminLayout({ children }) {
    const { url } = usePage();

    const navItems = [
        { label: "Dashboard", href: "/admin/dashboard", icon: <FiGrid /> },
        { label: "Produk", href: "/admin/produk", icon: <FiShoppingCart /> },
        { label: "Kategori", href: "/admin/kategori", icon: <FiFolder /> },
        { label: "Pesanan", href: "/admin/orders", icon: <FiClipboard /> },
        { label: "Manual Order", href: route("admin.order.create"), icon: <FiPlusSquare /> },
    ];

    return (
        <div className="flex h-screen bg-gradient-to-br from-[#fdfaf6] to-[#f5eee5] overflow-hidden">
            {/* Sidebar */}
            <aside className="w-64 bg-[#3e2f23] text-white flex flex-col p-6 shadow-2xl z-10">
                <h2 className="text-3xl font-bold mb-12 tracking-widest text-center font-serif">
                    Cafe Del
                </h2>

                <nav className="flex-1">
                    <ul className="space-y-3">
                        {navItems.map((item, i) => {
                            const isActive = url.startsWith(item.href);
                            return (
                                <li key={i}>
                                    <Link
                                        href={item.href}
                                        className={`flex items-center gap-3 px-4 py-3 rounded-lg font-medium transition-all
                                            ${isActive
                                                ? "bg-[#5a4233] text-white shadow-md"
                                                : "hover:bg-[#5a4233] hover:text-white text-gray-200"
                                            }`}
                                    >
                                        {item.icon} {item.label}
                                    </Link>
                                </li>
                            );
                        })}
                    </ul>
                </nav>

                {/* Logout */}
                <div className="mt-10">
                    <Link
                        href="/logout"
                        method="post"
                        as="button"
                        className="w-full flex items-center justify-center gap-2 px-4 py-3 bg-red-500 hover:bg-red-600 rounded-lg text-center transition font-semibold"
                    >
                        <FiLogOut /> Logout
                    </Link>
                </div>
            </aside>

            {/* Main Content */}
            <main className="flex-1 p-8 overflow-auto">
                <div className="bg-white p-8 rounded-3xl shadow-xl border border-gray-200 min-h-full transition-all">
                    {children}
                </div>
            </main>
        </div>
    );
}