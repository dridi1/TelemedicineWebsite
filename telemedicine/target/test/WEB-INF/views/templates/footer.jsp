<%@ page import="java.util.Calendar" %>
<!-- Enhanced Footer -->
<footer class="footer bg-dark text-white py-5">
    <div class="container">
        <div class="row g-4">
            <!-- Company Section -->
            <div class="col-md-6 col-lg-4">
                <div class="footer-brand mb-4">
                    <h3 class="h5 fw-bold text-primary">Virtual Health</h3>
                    <p class="text-white-50 text-decoration-none hover-text-primary">Your partner in digital healthcare solutions.</p>
                </div>
                <div class="d-flex gap-3">
                    <a href="${pageContext.request.contextPath}/about.jsp" 
                       class="btn btn-outline-light btn-sm rounded-pill" 
                       aria-label="About us">
                        About Us
                    </a>
                    <a href="${pageContext.request.contextPath}/contact.jsp" 
                       class="btn btn-outline-light btn-sm rounded-pill"
                       aria-label="Contact us">
                        Contact
                    </a>
                </div>
            </div>

            <!-- Navigation Links -->
            <div class="col-md-6 col-lg-2">
                <h4 class="h6 fw-bold mb-3 text-uppercase">Resources</h4>
                <ul class="list-unstyled">
                    <li class="mb-2">
                        <a href="${pageContext.request.contextPath}/blog.jsp" 
                           class="text-white text-decoration-none hover-text-primary"
                           aria-label="Read our blog">
                            Blog
                        </a>
                    </li>
                    <li class="mb-2">
                        <a href="${pageContext.request.contextPath}/faq.jsp" 
                           class="text-white text-decoration-none hover-text-primary"
                           aria-label="Frequently asked questions">
                            FAQs
                        </a>
                    </li>
                    <li class="mb-2">
                        <a href="${pageContext.request.contextPath}/privacy.jsp" 
                           class="text-white text-decoration-none hover-text-primary"
                           aria-label="Privacy policy">
                            Privacy Policy
                        </a>
                    </li>
                </ul>
            </div>

            <!-- Legal Section -->
            <div class="col-md-6 col-lg-2">
                <h4 class="h6 fw-bold mb-3 text-uppercase">Legal</h4>
                <ul class="list-unstyled">
                    <li class="mb-2">
                        <a href="${pageContext.request.contextPath}/terms.jsp" 
                           class="text-white text-decoration-none hover-text-primary"
                           aria-label="Terms of service">
                            Terms of Service
                        </a>
                    </li>
                    <li class="mb-2">
                        <a href="${pageContext.request.contextPath}/cookies.jsp" 
                           class="text-white text-decoration-none hover-text-primary"
                           aria-label="Cookie policy">
                            Cookie Policy
                        </a>
                    </li>
                    <li class="mb-2">
                        <a href="${pageContext.request.contextPath}/accessibility.jsp" 
                           class="text-white text-decoration-none hover-text-primary"
                           aria-label="Accessibility statement">
                            Accessibility
                        </a>
                    </li>
                </ul>
            </div>

            <!-- Social & Contact -->
            <div class="col-md-6 col-lg-4">
                <h4 class="h6 fw-bold mb-3 text-uppercase">Connect With Us</h4>
                <div class="social-links d-flex gap-3 mb-4">
                    <a href="#" class="text-white hover-text-primary" 
                       aria-label="Facebook page" 
                       data-bs-toggle="tooltip" 
                       data-bs-placement="top" 
                       title="Follow on Facebook">
                        <i class="fab fa-facebook-f fs-5"></i>
                    </a>
                    <a href="#" class="text-white hover-text-primary" 
                       aria-label="Twitter profile" 
                       data-bs-toggle="tooltip" 
                       title="Follow on Twitter">
                        <i class="fab fa-twitter fs-5"></i>
                    </a>
                    <a href="#" class="text-white hover-text-primary" 
                       aria-label="LinkedIn profile" 
                       data-bs-toggle="tooltip" 
                       title="Connect on LinkedIn">
                        <i class="fab fa-linkedin-in fs-5"></i>
                    </a>
                    <a href="#" class="text-white hover-text-primary" 
                       aria-label="YouTube channel" 
                       data-bs-toggle="tooltip" 
                       title="Watch on YouTube">
                        <i class="fab fa-youtube fs-5"></i>
                    </a>
                </div>

                <!-- Newsletter Form -->
                <form class="newsletter-form">
                    <div class="input-group">
                        <input type="email" 
                               class="form-control border-end-0" 
                               placeholder="Enter your email"
                               aria-label="Subscribe to newsletter">
                        <button class="btn btn-primary" 
                                type="button"
                                aria-label="Subscribe">
                            Subscribe
                        </button>
                    </div>
                    <small class="text-muted d-block mt-2">Get health insights delivered to your inbox</small>
                </form>
            </div>
        </div>

        <!-- Copyright & Legal -->
		<div class="border-top border-secondary mt-5 pt-4">  <!-- Changed border-dark to border-secondary -->
		    <div class="row align-items-center">
		        <div class="col-md-6 text-center text-md-start">
		            <p class="text-white-50 mb-0">  <!-- Changed text-muted to text-white-50 -->
		                &copy; <%= Calendar.getInstance().get(Calendar.YEAR) %> Virtual Health. 
		                All rights reserved.
		            </p>
		        </div>
		        <div class="col-md-6 text-center text-md-end">
		            <div class="d-inline-flex gap-3">
		                <a href="${pageContext.request.contextPath}/sitemap.jsp" 
		                   class="text-white-50 text-decoration-none hover-text-primary"
		                   aria-label="View sitemap">
		                    Sitemap
		                </a>
		                <a href="${pageContext.request.contextPath}/disclaimer.jsp" 
		                   class="text-white-50 text-decoration-none hover-text-primary" 
		                   aria-label="View disclaimer">
		                    Disclaimer
		                </a>
		            </div>
		        </div>
		    </div>
		</div>
    </div>
</footer>

<style>
    /* Enhanced Footer Styles */
    .footer {
        position: relative;
        font-size: 0.9rem;
    }
    
    .hover-text-primary:hover {
        color: #6a11cb !important;
        transition: color 0.3s ease;
    }
    
    .newsletter-form .form-control {
        background: rgba(255, 255, 255, 0.1);
        border-color: rgba(255, 255, 255, 0.2);
        color: white;
    }
    
    .back-to-top {
        position: fixed;
        bottom: 20px;
        right: 20px;
        opacity: 0;
        transition: opacity 0.3s ease;
    }
    
    .back-to-top.show {
        opacity: 1;
    }
    .text-footer-muted {
	    color: rgba(255, 255, 255, 0.6) !important;
	    transition: color 0.3s ease;
	}
	
	.text-footer-muted:hover {
	    color: var(--bs-primary) !important;
	}
</style>

<script>
    // Show/hide back-to-top button
    window.addEventListener('scroll', () => {
        const backToTop = document.querySelector('.back-to-top');
        backToTop.style.opacity = window.scrollY > 1000 ? '1' : '0';
    });
    
    // Initialize Bootstrap tooltips
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map(t => new bootstrap.Tooltip(t));
</script>