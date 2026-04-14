import math


def logmar_from_decimal(decimal_acuity: float) -> float:
    """
    将小数视力转换为 logMAR。

    输入:
        decimal_acuity: 小数视力，例如 1.0、0.8、0.5。

    输出:
        对应的 logMAR 值。
    """
    if decimal_acuity <= 0:
        raise ValueError("decimal_acuity 必须大于 0")

    return -math.log10(decimal_acuity)


def arcmin_to_rad(arcmin: float) -> float:
    """
    将角分转换为弧度。

    输入:
        arcmin: 角分（arcmin）。

    输出:
        对应的弧度值。
    """
    return arcmin * math.pi / 10800.0


def optotype_size_mm(test_distance_mm: float, decimal_acuity: float) -> float:
    """
    根据视距和小数视力，计算完整视标的物理尺寸（毫米）。

    计算逻辑与当前项目一致：
    1. 小数视力 -> logMAR
    2. logMAR -> MAR（角分）
    3. 视标总张角 = MAR * 5
    4. 用几何公式计算实际物理尺寸

    输入:
        test_distance_mm: 视距，单位 mm。例如 5 米应传 5000。
        decimal_acuity: 小数视力，例如 1.0、0.8、0.5。

    输出:
        视标的物理尺寸，单位 mm。
    """
    if test_distance_mm <= 0:
        raise ValueError("test_distance_mm 必须大于 0")

    logmar = logmar_from_decimal(decimal_acuity)
    mar_arcmin = math.pow(10.0, logmar)
    optotype_angle_arcmin = mar_arcmin * 5.0
    angle_rad = arcmin_to_rad(optotype_angle_arcmin)

    return 2.0 * test_distance_mm * math.tan(angle_rad / 2.0)


def detail_size_mm(test_distance_mm: float, decimal_acuity: float) -> float:
    """
    计算视标关键细节尺寸（单笔画宽度），单位 mm。

    输入:
        test_distance_mm: 视距，单位 mm。
        decimal_acuity: 小数视力。

    输出:
        视标单笔画宽度，单位 mm。
    """
    return optotype_size_mm(test_distance_mm, decimal_acuity) / 5.0


if __name__ == '__main__':
    d=400
    c=0.32
    print(optotype_size_mm(d,c))
    print(detail_size_mm(d, c))