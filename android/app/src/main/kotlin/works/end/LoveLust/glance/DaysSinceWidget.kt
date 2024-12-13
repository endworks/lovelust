package works.end.LoveLust.glance

import works.end.LoveLust.R

import java.time.LocalDateTime
import java.time.ZoneId
import java.time.format.DateTimeFormatter
import java.time.temporal.ChronoUnit

import kotlinx.serialization.json.Json

import android.content.Context

import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.tooling.preview.Preview

import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.currentState
import androidx.glance.background
import androidx.glance.state.GlanceStateDefinition
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.provideContent
import androidx.glance.layout.Box
import androidx.glance.layout.Column
import androidx.glance.layout.Alignment
import androidx.glance.layout.fillMaxSize
import androidx.glance.text.Text
import androidx.glance.text.TextStyle
import androidx.glance.text.FontWeight
import androidx.glance.unit.ColorProvider

import HomeWidgetGlanceState
import HomeWidgetGlanceStateDefinition

class DaysSinceWidget : GlanceAppWidget() {

  override val stateDefinition: GlanceStateDefinition<*>?
    get() = HomeWidgetGlanceStateDefinition()

  override suspend fun provideGlance(context: Context, id: GlanceId) {
    provideContent {
      GlanceContent(context, currentState())
    }
  }

  @Composable
  private fun GlanceContent(context: Context, currentState: HomeWidgetGlanceState) {
    val prefs = currentState.preferences
    val jsonString = prefs.getString("lastActivity", "{}")
    val withoutSexText = context.getString(R.string.without_sex)
    var daysText = context.getString(R.string.days)
    var days: Int = 0

    if (jsonString != null) {
      val json = Json { ignoreUnknownKeys = true }
      val widgetData = json.decodeFromString<ActivityWidgetData>(jsonString.toString())
      if (widgetData.sexualActivity != null) {
        val formatter = DateTimeFormatter.ISO_DATE_TIME
        val sexualActivityDate = LocalDateTime.parse(widgetData.sexualActivity.date, formatter)
        val today = LocalDateTime.now(ZoneId.of("UTC"))
        days = ChronoUnit.DAYS.between(sexualActivityDate, today).toInt()
        daysText = if (days == 1) context.getString(R.string.day) else context.getString(R.string.days)
      }
    }

    Box(
      modifier = GlanceModifier.fillMaxSize().background(Color.White),
      contentAlignment = Alignment.Center
    ) {

      // Add text in the center
      Column(horizontalAlignment = Alignment.CenterHorizontally) {
        Text(
          text = days.toString().uppercase(),
          style = TextStyle(
            fontSize = 64.sp,
            fontWeight = FontWeight.Bold,
            color = ColorProvider(Color.Black)
          )
        )
        Text(
          text = daysText.uppercase(),
          style = TextStyle(
            fontSize = 32.sp,
            color = ColorProvider(Color.Black)
          )
        )
        Text(
          text = withoutSexText.uppercase(),
          style = TextStyle(
            fontSize = 16.sp,
            color = ColorProvider(Color.Gray)
          )
        )
      }
    }
  }
}