<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us - Spectrum</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <style>
        @keyframes pulse {
            0%, 100% { opacity: 0.4; }
            50% { opacity: 0.6; }
        }
        @keyframes floatUp {
            0% {
                opacity: 0;
                transform: translateY(20px);
            }
            100% {
                opacity: 1;
                transform: translateY(0);
            }
        }
        .animate-float-up {
            animation: floatUp 0.8s ease forwards;
        }
        .tech-card {
            background: white;
            border-radius: 0.75rem;
            padding: 1.5rem;
            transition: all 0.3s;
        }
        .tech-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }
    </style>
</head>
<body class="bg-gradient-to-b from-white to-gray-50">
    <!-- Hero Section -->
    <section class="relative overflow-hidden py-20 md:py-28">
        <div class="absolute inset-0 bg-blue-900 bg-opacity-5"></div>
        <div class="absolute -top-24 -right-24 w-96 h-96 bg-blue-200 bg-opacity-20 rounded-full blur-3xl"
             style="animation: pulse 8s infinite ease-in-out"></div>
        <div class="container mx-auto px-6 relative z-10">
            <div class="max-w-3xl mx-auto text-center">
                <h1 class="text-4xl md:text-5xl font-bold text-gray-900 mb-6 tracking-tight">
                    Meet the Minds Behind <span class="text-blue-600">Spectrum</span>
                </h1>
                <p class="text-lg md:text-xl text-gray-700 leading-relaxed">
                    We're a dynamic duo of passionate developers dedicated to creating exceptional 
                    web experiences. Our combined expertise and collaborative spirit drive us to 
                    deliver innovative solutions that make a difference.
                </p>
            </div>
        </div>
    </section>

    <!-- Team Section -->
    <section class="py-16 md:py-24">
        <div class="container mx-auto px-6">
            <div class="text-center mb-16">
                <h2 class="text-3xl md:text-4xl font-bold text-gray-900 mb-4">Our Team</h2>
                <p class="text-lg text-gray-600 max-w-2xl mx-auto">The talent behind our success</p>
                <div class="h-1 w-16 bg-blue-600 mt-6 mx-auto"></div>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-12">
                <div class="animate-on-scroll opacity-0 bg-white rounded-xl overflow-hidden shadow-sm hover:shadow-md transition-all duration-300">
                    <div class="md:flex">
                        <div class="md:w-2/5 relative overflow-hidden">
                            <img src="https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?auto=compress&cs=tinysrgb&w=800" 
                                 alt="Slim Dridi" 
                                 class="w-full h-full object-cover">
                        </div>
                        <div class="p-6 md:p-8 md:w-3/5">
                            <h3 class="text-2xl font-bold text-gray-900 mb-1">Slim Dridi</h3>
                            <p class="text-blue-600 font-medium mb-4">Lead Developer</p>
                            <p class="text-gray-700 leading-relaxed mb-6">
                                With expertise in React, TypeScript, and Node.js, Slim brings creative problem-solving and technical excellence to every project. His commitment to clean code and user-centric design ensures our solutions are both powerful and intuitive.
                            </p>
                            <div class="flex space-x-4">
                                <a href="https://github.com" class="text-gray-500 hover:text-blue-600 transition-colors">
                                    <span class="sr-only">GitHub</span>
                                    <i class="icon-github"></i>
                                </a>
                                <a href="https://linkedin.com" class="text-gray-500 hover:text-blue-600 transition-colors">
                                    <span class="sr-only">LinkedIn</span>
                                    <i class="icon-linkedin"></i>
                                </a>
                                <a href="https://twitter.com" class="text-gray-500 hover:text-blue-600 transition-colors">
                                    <span class="sr-only">Twitter</span>
                                    <i class="icon-twitter"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="animate-on-scroll opacity-0 bg-white rounded-xl overflow-hidden shadow-sm hover:shadow-md transition-all duration-300">
                    <div class="md:flex">
                        <div class="md:w-2/5 relative overflow-hidden">
                            <img src="https://images.pexels.com/photos/3785079/pexels-photo-3785079.jpeg?auto=compress&cs=tinysrgb&w=800" 
                                 alt="Jed Belhajyahya" 
                                 class="w-full h-full object-cover">
                        </div>
                        <div class="p-6 md:p-8 md:w-3/5">
                            <h3 class="text-2xl font-bold text-gray-900 mb-1">Jed Belhajyahya</h3>
                            <p class="text-blue-600 font-medium mb-4">Senior Developer</p>
                            <p class="text-gray-700 leading-relaxed mb-6">
                                Specializing in front-end architecture, UI/UX, and cloud services, Jed's innovative approach and attention to detail help transform complex challenges into seamless solutions. His focus on performance optimization and modern development practices elevates our projects to new heights.
                            </p>
                            <div class="flex space-x-4">
                                <a href="https://github.com" class="text-gray-500 hover:text-blue-600 transition-colors">
                                    <span class="sr-only">GitHub</span>
                                    <i class="icon-github"></i>
                                </a>
                                <a href="https://linkedin.com" class="text-gray-500 hover:text-blue-600 transition-colors">
                                    <span class="sr-only">LinkedIn</span>
                                    <i class="icon-linkedin"></i>
                                </a>
                                <a href="https://twitter.com" class="text-gray-500 hover:text-blue-600 transition-colors">
                                    <span class="sr-only">Twitter</span>
                                    <i class="icon-twitter"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Approach Section -->
    <section class="py-16 bg-blue-50">
        <div class="container mx-auto px-6">
            <div class="text-center mb-16">
                <h2 class="text-3xl md:text-4xl font-bold text-gray-900 mb-4">Our Approach</h2>
                <p class="text-lg text-gray-600 max-w-2xl mx-auto">How we work</p>
                <div class="h-1 w-16 bg-blue-600 mt-6 mx-auto"></div>
            </div>

            <div class="max-w-4xl mx-auto">
                <div class="bg-white rounded-2xl shadow-sm p-8 md:p-12 animate-on-scroll opacity-0">
                    <p class="text-gray-700 leading-relaxed mb-6">
                        We believe in crafting websites that not only look stunning but also deliver 
                        exceptional functionality. Our approach combines technical excellence with 
                        creative design thinking to build solutions that stand out.
                    </p>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-8 mt-12">
                        <div class="group animate-on-scroll opacity-0">
                            <div class="h-1 w-16 bg-blue-500 mb-4 transition-all duration-300 group-hover:w-24"></div>
                            <h3 class="text-xl font-semibold text-gray-900 mb-3">Purposeful Code</h3>
                            <p class="text-gray-600">Every line of code we write is purposeful, clean, and maintainable.</p>
                        </div>
                        
                        <div class="group animate-on-scroll opacity-0">
                            <div class="h-1 w-16 bg-blue-500 mb-4 transition-all duration-300 group-hover:w-24"></div>
                            <h3 class="text-xl font-semibold text-gray-900 mb-3">Intentional Design</h3>
                            <p class="text-gray-600">Every design decision is deliberate, focusing on usability and aesthetics.</p>
                        </div>
                        
                        <div class="group animate-on-scroll opacity-0">
                            <div class="h-1 w-16 bg-blue-500 mb-4 transition-all duration-300 group-hover:w-24"></div>
                            <h3 class="text-xl font-semibold text-gray-900 mb-3">Thorough Testing</h3>
                            <p class="text-gray-600">Every feature is rigorously tested to ensure reliability and performance.</p>
                        </div>
                        
                        <div class="group animate-on-scroll opacity-0">
                            <div class="h-1 w-16 bg-blue-500 mb-4 transition-all duration-300 group-hover:w-24"></div>
                            <h3 class="text-xl font-semibold text-gray-900 mb-3">Continuous Learning</h3>
                            <p class="text-gray-600">We constantly evolve our skills to stay ahead of industry trends.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Contact Section -->
    <section class="py-20 md:py-28 bg-gray-50">
        <div class="container mx-auto px-6 text-center">
            <div class="animate-on-scroll opacity-0">
                <h2 class="text-3xl md:text-4xl font-bold text-gray-900 mb-4">
                    Let's Build Something Amazing Together
                </h2>
                <p class="text-lg text-gray-700 mb-12 max-w-2xl mx-auto">
                    Ready to transform your ideas into reality? We'd love to hear about your project 
                    and explore how we can help.
                </p>

                <a href="/contact" class="inline-flex items-center px-8 py-4 bg-blue-600 hover:bg-blue-700 text-white font-medium rounded-full transition-all duration-300 transform hover:-translate-y-1 shadow-md hover:shadow-lg">
                    <span class="mr-2">Contact Us</span>
                    <i class="icon-send"></i>
                </a>

                <div class="flex justify-center mt-12 space-x-6">
                    <a href="https://github.com" class="text-gray-500 hover:text-blue-600 transition-colors">
                        <i class="icon-github"></i>
                        <span class="sr-only">GitHub</span>
                    </a>
                    <a href="https://linkedin.com" class="text-gray-500 hover:text-blue-600 transition-colors">
                        <i class="icon-linkedin"></i>
                        <span class="sr-only">LinkedIn</span>
                    </a>
                    <a href="https://twitter.com" class="text-gray-500 hover:text-blue-600 transition-colors">
                        <i class="icon-twitter"></i>
                        <span class="sr-only">Twitter</span>
                    </a>
                    <a href="/contact" class="text-gray-500 hover:text-blue-600 transition-colors">
                        <i class="icon-message-square"></i>
                        <span class="sr-only">Contact</span>
                    </a>
                </div>
            </div>
        </div>
    </section>

    <script src="https://unpkg.com/lucide@latest"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const observer = new IntersectionObserver(
                (entries) => {
                    entries.forEach(entry => {
                        if (entry.isIntersecting) {
                            entry.target.classList.add('animate-float-up');
                            observer.unobserve(entry.target);
                        }
                    });
                },
                { threshold: 0.1 }
            );

            document.querySelectorAll('.animate-on-scroll').forEach(el => {
                observer.observe(el);
            });
        });

        lucide.createIcons();
    </script>
</body>
</html>