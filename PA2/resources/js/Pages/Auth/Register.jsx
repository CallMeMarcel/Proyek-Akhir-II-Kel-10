import { Head, Link, useForm } from '@inertiajs/react';
import GuestLayout from '@/Layouts/GuestLayout';
import InputError from '@/Components/InputError';
import InputLabel from '@/Components/InputLabel';
import PrimaryButton from '@/Components/PrimaryButton';
import TextInput from '@/Components/TextInput';
import { FiUser, FiMail, FiLock } from 'react-icons/fi'; // Import ikon dari react-icons

export default function Register() {
    const { data, setData, post, processing, errors, reset } = useForm({
        name: '',
        email: '',
        password: '',
        password_confirmation: '',
    });

    const submit = (e) => {
        e.preventDefault();
        post(route('register'), {
            onFinish: () => reset('password', 'password_confirmation'),
        });
    };

    return (
        <GuestLayout>
            <Head title="Register" />

            <form onSubmit={submit} className="space-y-6 bg-white p-8 shadow-md rounded-lg">
                <h2 className="text-2xl font-bold text-center text-gray-800">Create an Account</h2>

                {/* Name */}
                <div>
                    <InputLabel htmlFor="name" value="Name" />
                    <div className="relative mt-1">
                        <FiUser className="absolute left-3 top-3 text-gray-400" />
                        <TextInput
                            id="name"
                            name="name"
                            value={data.name}
                            className="pl-10 w-full border-gray-300 focus:ring-indigo-500 focus:border-indigo-500 rounded-md"
                            autoComplete="name"
                            isFocused={true}
                            onChange={(e) => setData('name', e.target.value)}
                            required
                        />
                    </div>
                    <InputError message={errors.name} className="mt-2" />
                </div>

                {/* Email */}
                <div>
                    <InputLabel htmlFor="email" value="Email" />
                    <div className="relative mt-1">
                        <FiMail className="absolute left-3 top-3 text-gray-400" />
                        <TextInput
                            id="email"
                            type="email"
                            name="email"
                            value={data.email}
                            className="pl-10 w-full border-gray-300 focus:ring-indigo-500 focus:border-indigo-500 rounded-md"
                            autoComplete="username"
                            onChange={(e) => setData('email', e.target.value)}
                            required
                        />
                    </div>
                    <InputError message={errors.email} className="mt-2" />
                </div>

                {/* Password */}
                <div>
                    <InputLabel htmlFor="password" value="Password" />
                    <div className="relative mt-1">
                        <FiLock className="absolute left-3 top-3 text-gray-400" />
                        <TextInput
                            id="password"
                            type="password"
                            name="password"
                            value={data.password}
                            className="pl-10 w-full border-gray-300 focus:ring-indigo-500 focus:border-indigo-500 rounded-md"
                            autoComplete="new-password"
                            onChange={(e) => setData('password', e.target.value)}
                            required
                        />
                    </div>
                    <InputError message={errors.password} className="mt-2" />
                </div>

                {/* Confirm Password */}
                <div>
                    <InputLabel htmlFor="password_confirmation" value="Confirm Password" />
                    <div className="relative mt-1">
                        <FiLock className="absolute left-3 top-3 text-gray-400" />
                        <TextInput
                            id="password_confirmation"
                            type="password"
                            name="password_confirmation"
                            value={data.password_confirmation}
                            className="pl-10 w-full border-gray-300 focus:ring-indigo-500 focus:border-indigo-500 rounded-md"
                            autoComplete="new-password"
                            onChange={(e) => setData('password_confirmation', e.target.value)}
                            required
                        />
                    </div>
                    <InputError message={errors.password_confirmation} className="mt-2" />
                </div>

                {/* Submit & Link to Login */}
                <div className="flex flex-col items-center space-y-4">
                    <PrimaryButton className="w-full py-2" disabled={processing}>
                        Register
                    </PrimaryButton>
                    <p className="text-sm text-gray-600">
                        Already have an account?{' '}
                        <Link href={route('login')} className="text-indigo-600 font-semibold hover:underline">
                            Sign in
                        </Link>
                    </p>
                </div>
            </form>
        </GuestLayout>
    );
}
