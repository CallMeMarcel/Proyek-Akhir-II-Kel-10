import { Head, Link, useForm } from '@inertiajs/react';
import GuestLayout from '@/Layouts/GuestLayout';
import Checkbox from '@/Components/Checkbox';
import InputError from '@/Components/InputError';
import InputLabel from '@/Components/InputLabel';
import PrimaryButton from '@/Components/PrimaryButton';
import TextInput from '@/Components/TextInput';
import { FiMail, FiLock } from 'react-icons/fi';

export default function Login({ status, canResetPassword }) {
    const { data, setData, post, processing, errors, reset } = useForm({
        email: '',
        password: '',
        remember: false,
    });

    const submit = (e) => {
        e.preventDefault();
        post(route('login'), { onFinish: () => reset('password') });
    };

    return (
        <GuestLayout>
            <Head title="Login" />

            <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-[#FFF9F0] to-[#F7E7CE] px-6 py-12">
                <div className="w-full max-w-md space-y-8 p-10 rounded-2xl bg-white shadow-2xl border border-[#E0D4B9]">
                    <div className="text-center">
                        <h2 className="text-4xl font-extrabold text-[#4B2E2E]">
                            Welcome <span className="text-[#A0522D]">Admin</span> ☕
                        </h2>
                        <p className="mt-2 text-sm text-[#6B4F4F]">
                            Log in to manage your coffee shop
                        </p>
                        {status && (
                            <div className="mt-4 text-green-600 font-semibold text-sm">
                                {status}
                            </div>
                        )}
                    </div>

                    <form onSubmit={submit} className="space-y-6">
                        {/* Email Input */}
                        <div>
                            <InputLabel htmlFor="email" value="Email" />
                            <div className="relative mt-1">
                                <FiMail className="absolute left-3 top-3 text-[#A0522D]" />
                                <TextInput
                                    id="email"
                                    type="email"
                                    name="email"
                                    value={data.email}
                                    className="pl-10 w-full border rounded-lg py-2 px-4 border-[#D2B48C] focus:border-[#A0522D] focus:ring-2 focus:ring-[#A0522D]/30 text-[#4B2E2E] transition-all"
                                    autoComplete="username"
                                    isFocused={true}
                                    onChange={(e) => setData('email', e.target.value)}
                                />
                            </div>
                            <InputError message={errors.email} className="mt-2" />
                        </div>

                        {/* Password Input */}
                        <div>
                            <InputLabel htmlFor="password" value="Password" />
                            <div className="relative mt-1">
                                <FiLock className="absolute left-3 top-3 text-[#A0522D]" />
                                <TextInput
                                    id="password"
                                    type="password"
                                    name="password"
                                    value={data.password}
                                    className="pl-10 w-full border rounded-lg py-2 px-4 border-[#D2B48C] focus:border-[#A0522D] focus:ring-2 focus:ring-[#A0522D]/30 text-[#4B2E2E] transition-all"
                                    autoComplete="current-password"
                                    onChange={(e) => setData('password', e.target.value)}
                                />
                            </div>
                            <InputError message={errors.password} className="mt-2" />
                        </div>

                        {/* Remember Me and Forgot Password */}
                        <div className="flex items-center justify-between text-sm text-[#6B4F4F]">
                            <label className="flex items-center">
                                <Checkbox
                                    name="remember"
                                    checked={data.remember}
                                    onChange={(e) => setData('remember', e.target.checked)}
                                />
                                <span className="ml-2">Remember me</span>
                            </label>

                            {canResetPassword && (
                                <Link
                                    href={route('password.request')}
                                    className="text-[#A0522D] hover:underline transition"
                                >
                                    Forgot?
                                </Link>
                            )}
                        </div>

                        {/* Submit Button */}
                        <div>
                            <PrimaryButton
                                className="w-full bg-[#A0522D] hover:bg-[#8B4513] text-white py-2 rounded-lg font-bold transition-all duration-300"
                                disabled={processing}
                            >
                                Log in
                            </PrimaryButton>
                        </div>

                        {/* Register Link */}
                        <div className="text-center text-sm text-[#6B4F4F]">
                            Don't have an account?{' '}
                            <Link
                                href={route('register')}
                                className="text-[#A0522D] font-semibold hover:underline transition"
                            >
                                Sign up
                            </Link>
                        </div>
                    </form>
                </div>
            </div>
        </GuestLayout>
    );
}
