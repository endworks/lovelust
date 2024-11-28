package works.end.LoveLust.glance

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews

import androidx.compose.runtime.Composable
import androidx.compose.ui.unit.dp
import androidx.compose.ui.graphics.Color
import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.Button
import androidx.glance.currentState
import androidx.glance.background
import androidx.glance.state.GlanceStateDefinition
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.provideContent
import androidx.glance.layout.Box
import androidx.glance.layout.Column
import androidx.glance.layout.padding
import androidx.glance.text.Text

import HomeWidgetGlanceState
import HomeWidgetGlanceStateDefinition

class LastActivityWidget : GlanceAppWidget() {

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
    val counter = prefs.getInt("counter", 0)
    Box(modifier = GlanceModifier.background(Color.White).padding(16.dp)) {
      Column() {
        Text(
            counter.toString()
        )
      }
    }
  }
}