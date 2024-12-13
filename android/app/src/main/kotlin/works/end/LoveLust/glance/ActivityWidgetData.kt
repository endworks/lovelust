package works.end.LoveLust.glance

import kotlinx.serialization.Serializable

@Serializable
data class ActivityWidgetData(
    val soloActivity: Activity? = null,
    val sexualActivity: Activity? = null,
    val partner: Partner? = null,
    val safety: String? = null,
    val moodEmoji: String? = null,
    val privacyMode: Boolean
)