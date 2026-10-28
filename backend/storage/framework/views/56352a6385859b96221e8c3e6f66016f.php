<?php
    $companyName = \App\Support\AppSettings::companyName();
    $phone = \App\Support\AppSettings::companyPhone() ?: '+1 (800) 555-0199';
    $email = \App\Support\AppSettings::companyEmail();
    $address = \App\Support\AppSettings::address() ?: '100 Harbor Way, Seattle, WA';
?>
<footer class="bg-navy-950 text-navy-100">
    <div class="container-page grid gap-12 py-16 lg:grid-cols-[1.4fr_1fr_1fr_1fr]">
        <div>
            <a href="<?php echo e(route('home')); ?>" class="flex items-center gap-2.5" aria-label="<?php echo e($companyName); ?> home">
                <span class="font-display text-xl font-bold text-white"><?php echo e($companyName); ?></span>
            </a>
            <p class="mt-4 max-w-xs text-sm leading-6 text-navy-200">
                Global logistics, shipment tracking, route visibility, secure payment requests, and admin-managed customer support.
            </p>
            <div class="mt-6 space-y-2 text-sm">
                <p><?php echo e($phone); ?></p>
                <p><?php echo e($email); ?></p>
                <p><?php echo e($address); ?></p>
            </div>
        </div>
        <div>
            <h3 class="text-sm font-semibold uppercase tracking-wider text-white">Company</h3>
            <ul class="mt-4 space-y-3 text-sm">
                <li><a href="<?php echo e(route('about')); ?>" class="text-navy-200 hover:text-white">About</a></li>
                <li><a href="<?php echo e(route('careers')); ?>" class="text-navy-200 hover:text-white">Careers</a></li>
                <li><a href="<?php echo e(route('contact')); ?>" class="text-navy-200 hover:text-white">Contact</a></li>
            </ul>
        </div>
        <div>
            <h3 class="text-sm font-semibold uppercase tracking-wider text-white">Solutions</h3>
            <ul class="mt-4 space-y-3 text-sm">
                <li><a href="<?php echo e(route('services')); ?>" class="text-navy-200 hover:text-white">Shipping Services</a></li>
                <li><a href="<?php echo e(route('rates')); ?>" class="text-navy-200 hover:text-white">Rates & Pricing</a></li>
                <li><a href="<?php echo e(route('services.international')); ?>" class="text-navy-200 hover:text-white">International</a></li>
            </ul>
        </div>
        <div>
            <h3 class="text-sm font-semibold uppercase tracking-wider text-white">Support</h3>
            <ul class="mt-4 space-y-3 text-sm">
                <li><a href="<?php echo e(route('tracking')); ?>" class="text-navy-200 hover:text-white">Track a Shipment</a></li>
                <li><a href="<?php echo e(route('support')); ?>" class="text-navy-200 hover:text-white">Help Center</a></li>
                <li><a href="<?php echo e(route('faq')); ?>" class="text-navy-200 hover:text-white">FAQ</a></li>
            </ul>
        </div>
    </div>
    <div class="border-t border-white/10">
        <div class="container-page flex flex-col items-center justify-between gap-2 py-5 text-xs text-navy-300 sm:flex-row">
            <p><?php echo e(\App\Support\AppSettings::footer()); ?></p>
            <div class="flex flex-wrap items-center gap-x-5 gap-y-1">
                <a href="<?php echo e(route('support')); ?>" class="hover:text-white">Privacy & Security</a>
                <a href="<?php echo e(route('support')); ?>" class="hover:text-white">Terms</a>
            </div>
        </div>
    </div>
</footer>
<?php /**PATH C:\Users\PAPAMNESTY\Desktop\fedex logistic\Fed\FedExUs\backend\resources\views/components/site-footer.blade.php ENDPATH**/ ?>