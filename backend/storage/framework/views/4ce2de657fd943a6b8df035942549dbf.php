<?php $attributes ??= new \Illuminate\View\ComponentAttributeBag;

$__newAttributes = [];
$__propNames = \Illuminate\View\ComponentAttributeBag::extractPropNames(([    'variant' => 'primary',    'size' => 'md',    'href' => null,    'type' => 'button',]));

foreach ($attributes->all() as $__key => $__value) {
    if (in_array($__key, $__propNames)) {
        $$__key = $$__key ?? $__value;
    } else {
        $__newAttributes[$__key] = $__value;
    }
}

$attributes = new \Illuminate\View\ComponentAttributeBag($__newAttributes);

unset($__propNames);
unset($__newAttributes);

foreach (array_filter(([    'variant' => 'primary',    'size' => 'md',    'href' => null,    'type' => 'button',]), 'is_string', ARRAY_FILTER_USE_KEY) as $__key => $__value) {
    $$__key = $$__key ?? $__value;
}

$__defined_vars = get_defined_vars();

foreach ($attributes->all() as $__key => $__value) {
    if (array_key_exists($__key, $__defined_vars)) unset($$__key);
}

unset($__defined_vars, $__key, $__value); ?><?php    $variantClasses = [        'primary' => 'bg-azure-500 text-white shadow-glow hover:bg-azure-600 hover:-translate-y-0.5 active:translate-y-0',        'secondary' => 'bg-navy-900 text-white hover:bg-navy-800 hover:-translate-y-0.5 active:translate-y-0',        'accent' => 'bg-gold-500 text-navy-950 hover:bg-gold-400 hover:-translate-y-0.5 active:translate-y-0',        'outline' => 'border border-navy-200 bg-white text-navy-900 hover:border-azure-400 hover:text-azure-600',        'ghost' => 'bg-transparent text-navy-700 hover:bg-navy-50',        'masthead' => 'bg-transparent text-white hover:bg-white/10',    ][$variant];    $sizeClasses = [        'sm' => 'min-h-9 px-4 text-[13px]',        'md' => 'min-h-11 px-6 text-sm',        'lg' => 'min-h-12 px-7 text-[15px]',    ][$size];    $classes = "focus-ring inline-flex items-center justify-center gap-2 rounded-full font-semibold transition-all duration-200 disabled:cursor-not-allowed disabled:opacity-60 {$variantClasses} {$sizeClasses}";?><?php if(\Livewire\Mechanisms\ExtendBlade\ExtendBlade::isRenderingLivewireComponent()): ?><!--[if BLOCK]><![endif]--><?php endif; ?><?php if($href): ?>    <a href="<?php echo e($href); ?>" class="<?php echo e($classes); ?>" <?php echo e($attributes); ?>>        <?php echo e($slot); ?>    </a><?php else: ?>    <button type="<?php echo e($type); ?>" class="<?php echo e($classes); ?>" <?php echo e($attributes); ?>>        <?php echo e($slot); ?>    </button><?php endif; ?><?php if(\Livewire\Mechanisms\ExtendBlade\ExtendBlade::isRenderingLivewireComponent()): ?><!--[if ENDBLOCK]><![endif]--><?php endif; ?><?php /**PATH C:\Users\PAPAMNESTY\Desktop\fedex logistic\Fed\FedExUs\backend\resources\views/components/ui/button.blade.php ENDPATH**/ ?>